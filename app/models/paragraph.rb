
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
  belongs_to :identity
  belongs_to :identity_document, class_name: "Document"
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

  
  # Instance
  attr_accessible :prototype_id
  attr_reader :prototype_id
  def prototype_id=(value); @prototype_id = value.kind_of?(String) && value.gsub(/\D/, '') end


  # Location
  def location?
    (id % 6) == 0
  end

  def lat
    51.833896
  end

  def lng
    107.587538
  end


  # Cache
  include Identity::Cache
end
