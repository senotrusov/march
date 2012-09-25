
 # Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.


class Section < ActiveRecord::Base
  # Associations
  belongs_to :identity
  belongs_to :identity_poster, class_name: 'Poster'
  belongs_to :identity_document, class_name: 'Document'
  belongs_to :document
  belongs_to :proto_document, class_name: 'Document'
  has_many :paragraphs, order: 'id', inverse_of: :section, conditions: { deleted: false }
  has_many :line_paragraphs, class_name: 'Paragraph', primary_key: 'line_id', order: 'id', inverse_of: :section, conditions: { deleted: false }

  def poster_ids
    proto_or_self.paragraphs.map {|p| [p.identity_poster_id, p.proto_identity_poster_id] }.flatten.compact.uniq
  end


  # Image
  include Upload
  attr_accessible :image, :image_cache, :remove_image
  mount_uploader :image, ImageUploader

  
  # Paragraphs behaviour
  attr_accessible :writable_by, :sort_by

  attr_enumerable :writable_by, %w[public contributor document_poster]
  attr_enumerable :sort_by, %w[created_at paragraphs_order]
  
  validates :writable_by, presence: true, unless: :is_unsaved_instance_with_bad_prototype
  validates :sort_by, presence: true, unless: :is_unsaved_instance_with_bad_prototype


  # Text attributes
  attr_accessible :title
  normalize_text :title
  validates :title, length: { in: 1..columns_hash['title'].limit }, unless: :is_unsaved_instance_with_bad_prototype


  # Frame
  attr_accessible :frame, as: [:default, :instance, :instance_update]
  attr_reader :frame
  def frame=(value); @frame = value.to_i end


  # Identity cache
  include Identity::Cache


  # Prototyping
  include Prototyping
  attr_prototype_copied :writable_by, :sort_by, :title, :paragraphs_order


  # Deletion
  def deleted?
    deleted_mark? || document.deleted?
  end

  def deleted_mark?
    deleted == true
  end

  def mark_as_deleted
    self.deleted = true
    self.deleted_at = Time.zone.now
  end

  def move_all_images_to_deleted
    move_image_to_deleted
    proto_or_self.paragraphs.each(&:move_image_to_deleted) unless any_other_existing_instances?
  end

  after_save :move_all_images_to_deleted, if: :deleted_mark?
  

  # Creation
  module SectionCreator
    def new(attributes = {}, options = {}, &block)
      attributes = (attributes.kind_of?(Hash) ? attributes.dup : {}).with_indifferent_access

      paragraphs = attributes.extract_array(:paragraphs).map {|paragraph| paragraph.is_a?(Paragraph) ? paragraph : Paragraph.new(paragraph) }
      
      created = super(attributes, options, &block)
      
      created.paragraphs = paragraphs
      
      created
    end
  end
  extend SectionCreator

  def assign_self_and_paragraphs_identity identity, remote_ip
    raise 'Can only be called on new records' unless new_record?

    ([self] + paragraphs).each {|i| i.assign_identity(identity, remote_ip) }
  end


  # Dirty checks
  def save_needed?
    new_record? || changed? || (image.cached? && !remove_image?) || (remove_image? && !image.cached?)
  end


  # Authorisation
  def can_create_paragraphs? poster
    case writable_by
      when 'public'
        true
      when 'contributor'
        poster_ids.include?(poster.id)
      when 'document_poster'
        proto_or_self.document.poster_id == poster.id
    end
  end
end
