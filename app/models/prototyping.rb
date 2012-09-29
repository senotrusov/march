
#  Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


module Prototyping

  def self.included base
    base.extend ClassMethods
    base.class_eval do
      cattr_accessor :copy_prototype_attrs

      attr_accessible :is_instance, as: [:default, :instance, :instance_update]
      attr_accessible :prototype_id, as: :instance

      before_validation :copy_prototype,            if: :new_record?
      validate          :is_prototype_exists,       if: :new_record?
      before_save       :copy_prototype_image_attr, if: :new_record?
      after_save        :copy_prototype_image_file
      after_save        :set_prototype_line_id
      after_save        :propagate_prototype_changes

      # if line_id IS NULL, then model does not have other instances
      has_many :instances,
        class_name: base.name,
        foreign_key: 'line_id',
        primary_key: 'line_id',
        order: 'id',
        conditions: { deleted: false }
    end
  end

  def instances_without_self
    instances.reject {|instance| instance.id == id }
  end

  def any_other_existing_instances?
    line_id && instances.where('id != ?', id).any? {|model| !model.deleted? }
  end

  module ClassMethods
    def attr_prototype_copied *attrs
      (self.copy_prototype_attrs ||= []).concat attrs
    end

    def find_any_instance id
      (found = find_by_id(id)) && !found.deleted? && found || where(line_id: id).where('id != line_id').detect {|model| !model.deleted? }
    end
    
    def find_any_instance! id
      find_any_instance(id) || raise(ActiveRecord::RecordNotFound, "Couldn't find any #{self} instance with id=#{id}")
    end

    def new(attributes = {}, options = {}, &block)
      if attributes[:is_instance].to_s == 'true'
        options[:as] = :instance
      end
      super(attributes, options, &block)
    end
  end


  # Preventing modification of already existing instance, and existing model to became instance
  def assign_attributes(new_attributes, options = {})
    if is_instance || new_attributes[:is_instance].to_s == 'true'
      options[:as] = new_record? ? :instance : :instance_update
    end

    super(new_attributes, options)
  end

  def is_instance= value
    @is_instance = (value.to_s == 'true')
  end

  def is_instance
    @is_instance || (line_id && line_id != id)
  end

  def prototype_id= value
    @prototype_id = value.kind_of?(String) ? ((value = value.gsub(/\D/, '')) && value.empty? ? nil : value.to_i) : value
  end

  def prototype_id
    @prototype_id
  end

  def prototype
    @prototype ||= (@is_instance && @prototype_id && self.class.find_any_instance(@prototype_id))
  end

  
  class ProtoCache
    ATTRS = [ :created_at,
              :updated_at,
              :identity_id,
              :identity_poster_id,
              :identity_name,
              :identity_board_slug,
              :identity_document_id,
              :document_id ]

    def initialize model
      @model = model
    end

    def method_missing name, *args, &block
      case name
        when :id
          @model.line_id
        when :paragraphs
          @model.line_paragraphs *args
        when :document
          @model.proto_document *args
        else
          @model.send (ATTRS.include?(name) ? "proto_#{name}" : name), *args, &block
      end
    end
  end

  def proto_or_self
    is_instance ? proto_cache : self
  end

  def proto_cache
    @proto_cache ||= ProtoCache.new(self)
  end

  def proto_cache= model
    ProtoCache::ATTRS.each {|attr| self.send("proto_#{attr}=", model.send(attr)) if self.respond_to?("proto_#{attr}=") }
  end


  def copy_prototype
    if prototype
      if prototype.is_instance
        self.line_id = prototype.line_id
        self.proto_cache = prototype.proto_cache
      else
        self.line_id = prototype.id
        self.proto_cache = prototype
      end

      copy_prototype_attrs.each {|attr| self.send("#{attr}=", prototype.send(attr)) }
    end
  end

  def is_unsaved_instance_with_bad_prototype
    new_record? && @is_instance && !prototype
  end

  def is_prototype_exists
    if @is_instance && !prototype
      errors.add(:prototype_id, "must exist")
    end
  end

  def copy_prototype_image_attr
    copy_image_attr(prototype) if prototype
  end

  def copy_prototype_image_file
    copy_image_file(prototype) if prototype
  end

  def set_prototype_line_id
    if prototype && !prototype.line_id
      prototype.line_id = prototype.id
      prototype.save!
    end
  end

  def propagate_prototype_changes
    if line_id == id
      instances_without_self.each do |instance|
        next if instance.deleted?

        copy_prototype_attrs.each {|attr| instance.send("#{attr}=", send(attr)) }
        instance.proto_updated_at = updated_at

        instance.copy_image_attr self
        instance.save!
        instance.copy_image_file self
      end
    end
  end

end
