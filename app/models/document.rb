
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


class Document < ActiveRecord::Base
  # Associations
  belongs_to :poster
  belongs_to :identity
  belongs_to :board
  has_many :identities, inverse_of: :document
  has_many :sections,   inverse_of: :document, autosave: false, conditions: { deleted: false }


  # Image
  include Upload
  attr_accessible :image, :image_cache, :remove_image
  mount_uploader :image, ImageUploader


  # Text attributes
  attr_accessible :title, :url

  normalize_text :title, :url

  validates :title,   length: { in: 3..columns_hash['title'].limit }
  validates :url,     length: { in: 0..columns_hash['url'].limit }

  
  # Sections framing
  SECTION_FRAMES = 3

  serialize :sections_framing, MultiJsonSerializer.new

  def framed_sections_factory
    Array.new(SECTION_FRAMES){[]}
  end

  def clear_framed_sections
    @framed_sections = framed_sections_factory
  end

  def framed_sections
    @framed_sections ||=
      sections_framing && sections_framing.map {|frame| frame.map {|section_id| sections.detect {|section| section.id == section_id }}} ||
      framed_sections_factory
  end

  def push_framed_section section
    framed_sections[section.frame && (0..SECTION_FRAMES).include?(section.frame) && section.frame || 0].push(section)
  end

  def framed_section_ids
    framed_sections.map {|frame| frame.map{|section| section.id}.compact }
  end

  def map_framed_sections
    self.sections_framing = framed_section_ids
  end
  before_save :map_framed_sections

  def section_framing_changed?
    sections_framing != framed_section_ids
  end

  module DirtyExtensions
    def changed?
      super || section_framing_changed?
    end
  end
  include DirtyExtensions


  # Scopes
  scope :eager,
    includes(:identities).
    includes(:sections => [:paragraphs, :line_paragraphs])

  scope :eager_with_instances,
    includes(:identities).
    includes(:sections => [:instances, {:paragraphs => :instances}])

  scope :ordered, order(ORDER = "id DESC")


  # Location
  include Geo::Model
  validates :location, presence: true

  def paragraphs_with_location
    @paragraphs_with_location ||= sections.map {|s| s.proto_or_self.paragraphs.select {|p| p.location?} }.flatten
  end


  # Creation
  module DocumentCreator
    def new(attributes = {}, options = {}, &block)
      attributes = (attributes.kind_of?(Hash) ? attributes.dup : {}).with_indifferent_access

      sections = attributes.extract_array(:sections).map {|section| section.is_a?(Section) ? section : Section.new(section) }
      
      created = super(attributes, options, &block)
      
      created.sections = sections

      sections.each {|section| created.push_framed_section(section) }
      
      created
    end
  end
  extend DocumentCreator


  # Deletion
  scope :alive, where(deleted: false)

  def deleted?
    deleted_mark?
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
    sections.each(&:move_all_images_to_deleted)
  end

  after_save :move_all_images_to_deleted, if: :deleted_mark?

  
  # Dirty checks
  def save_needed?
    changed? || sections.any? {|section| section.save_needed? } || (image.cached? && !remove_image?) || (remove_image? && !image.cached?)
  end


  # Authorisation
  def can_update? poster
    poster && poster.id == poster_id
  end

  def can_destroy? poster
    poster && poster.id == poster_id
  end
end
