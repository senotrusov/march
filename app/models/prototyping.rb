module Prototyping

  def self.included(base)
    base.class_eval do
      attr_accessible :prototype_id
      attr_reader     :prototype_id

      validate          :is_prototype_exists
      before_validation :copy_prototype
      before_save       :copy_prototype_image_attr
      after_save        :copy_prototype_image_file

      cattr_accessor :copy_prototype_attrs
    end
  end

  class ProtoCache
    def initialize model
      @model = model
    end

    def method_missing name, *args, &block
      if name == :id
        @model.line_id
      elsif name == :paragraphs
        @model.line_paragraphs
      else
        @model.__send__ "proto_#{name}", *args, &block
      end
    end
  end

  def prototype_id= value
    @prototype_id = value.kind_of?(String) ? ((value = value.gsub(/\D/, '')) && (value.present?) ? value.to_i : nil) : value
  end

  def prototype
    @prototype ||= (@prototype_id && self.class.find_by_id(@prototype_id))
  end

  def is_prototype_exists
    if @prototype_id && !prototype
      errors.add(:prototype_id, "must exist")
    end
  end

  def proto_or_self
    line_id? ? proto_cache : self
  end

  def proto_cache
    @proto_cache ||= ProtoCache.new(self)
  end

  def proto_cache= model
    %w( created_at
        updated_at
        identity_id
        identity_name
        identity_board_slug
        identity_document_id ).each {|attr| self.__send__("proto_#{attr}=", model.__send__(attr))}
  end

  def copy_prototype
    if prototype
      if prototype.line_id?
        self.line_id = prototype.line_id
        self.proto_cache = prototype.proto_cache
      else
        self.line_id = prototype.id
        self.proto_cache = prototype
      end

      copy_prototype_attrs.each {|attr| self.__send__("#{attr}=", prototype.__send__(attr))} 
    end
  end

  def copy_prototype_image_attr
    self.write_uploader(:image, prototype.image_identifier) if prototype && prototype.image_identifier
  end

  def copy_prototype_image_file
    if prototype && prototype.image_identifier
      root = Pathname.new(CarrierWave.root)
      (root + image.store_dir).parent.mkpath()
      FileUtils.cp_r root + prototype.image.store_dir, root + image.store_dir
    end
  end

end
