
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


class Paragraph < ActiveRecord::Base
  # Associations
  belongs_to :poster_identity
  belongs_to :poster_identity_document, class_name: "Document"
  belongs_to :section
  has_many :instances, class_name: "Paragraph", foreign_key: "line_id", primary_key: "line_id" # if line_id IS NULL, then paragraph does not have other instances


  # Image
  attr_accessible :image, :image_cache, :remove_image
  mount_uploader :image, ImageUploader


  # Text attributes
  attr_accessible :title, :url, :message

  normalize_text :title, :url, :message

  validates :title,   length: { in: 0..columns_hash['title'].limit }
  validates :url,     length: { in: 0..columns_hash['url'].limit }
  validates :message, length: { in: 0..columns_hash['message'].limit }


  # Location
  def location?
    rand > 0.7
  end

  def lat
    51.833896
  end

  def lng
    107.587538
  end


  # Helpers
  def assign_poster_identity identity, addr
    self.poster_identity                     = identity
    self.poster_identity_document            = identity.document
    self.poster_identity_document_board_slug = identity.document.board.slug
    self.poster_identity_identity            = identity.identity
    self.poster_addr                         = addr
  end
end
