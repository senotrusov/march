
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
  belongs_to :poster_identity
  belongs_to :poster_identity_document, class_name: "Document"
  belongs_to :document
  has_many :instances, class_name: "Section", foreign_key: "line_id", primary_key: "line_id" # if line_id IS NULL, then section does not have other instances
  has_many :section_versions
  has_many :paragraphs

  
  # Image
  attr_accessible :image, :image_cache, :remote_image_url, :remove_image
  mount_uploader :image, ImageUploader

  
  # Paragraphs behaviour
  attr_accessible :public_writable, :contributor_writable

  
  # Text attributes
  attr_accessible :title
  normalize_text :title
  validates :title, length: { in: 1..columns_hash['title'].limit }
  
  # Helpers
  def assign_poster_identity identity, addr
    self.poster_identity          = identity
    self.poster_identity_document = identity.document
    self.poster_identity_identity = identity.identity
    self.poster_addr              = addr
  end
end
