#  encoding: UTF-8

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


# TODO: Ensure attr_accessible as: [:instance_update] does not add security and logical side-effects

class Paragraph < ActiveRecord::Base
  # Associations
  belongs_to :identity
  belongs_to :identity_poster, class_name: 'Poster'
  belongs_to :identity_document, class_name: 'Document'
  belongs_to :section

  # Image
  include Upload
  attr_accessible :image, :image_cache, :remove_image, as: [:default, :instance_update]
  mount_uploader :image, ImageUploader


  # Text attributes
  attr_accessible :message, as: [:default, :instance_update]
  normalize_newline :message
  validates :message, length: { in: 0..columns_hash['message'].limit }

  validate :reserved_chars

  def reserved_chars
    if message
      if message.match(/^[#][^#]/) || message.match(/^=+\s*$/)
        errors.add(:message, "level 1 headings are reserved for future use")
        
      elsif message.match(/^#*\s*[§¶:]/)
        errors.add(:message, "lines and headings, started with §, ¶ or : are reserved for future use")

      end
    end
  end


  # Location
  include Geo::Model
  attr_accessible :location, :zoom, as: [:default, :instance_update]


  # Identity cache
  include Identity::Cache


  # Prototyping
  include Prototyping
  attr_prototype_copied :message, :lat, :lng, :zoom


  # Deletion
  def deleted?
    deleted_mark? || (section.deleted? && !section.any_other_existing_instances?)
  end

  def deleted_mark?
    deleted == true
  end

  def mark_as_deleted
    self.deleted = true
    self.deleted_at = Time.zone.now
  end

  after_save :move_image_to_deleted, if: :deleted_mark?

  def ensure_not_deleted
    raise(ActiveRecord::RecordNotFound, "Couldn't find #{self.class} with id=#{id}") if deleted?
    self
  end


  # Authorisation
  def can_destroy? poster
    poster && (poster.id == identity_poster_id || poster.id == section.proto_or_self.identity_poster_id)
  end

  def can_update? poster
    # Check if current poster is a paragraph original author
    # He can edit an original paragraph or any instance of that paragraph
    poster && poster.id == proto_or_self.identity_poster_id
  end
end
