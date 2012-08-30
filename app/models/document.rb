
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


class Document < ActiveRecord::Base
  # Associations
  belongs_to :poster
  belongs_to :identity
  belongs_to :board
  has_many :identities
  has_many :sections


  # Image
  attr_accessible :image, :image_cache, :remove_image
  mount_uploader :image, ImageUploader


  # Text attributes
  attr_accessible :title, :url, :message

  normalize_text :title, :url, :message

  validates :title,   length: { in: 1..columns_hash['title'].limit }
  validates :url,     length: { in: 0..columns_hash['url'].limit }
  validates :message, length: { in: 0..columns_hash['message'].limit }

  
  # Sections framing
  serialize :sections_framing, MultiJsonSerializer.new(Array)

  def framed_sections
    sections_framing.map {|frame| frame.map {|section_id| sections.detect {|section| section.id == section_id }}}
  end


  # Scopes
  scope :eager,
    includes(:identities).
    includes(:sections => [:instances, {:paragraphs => :instances}])

  scope :ordered, order(ORDER = "id DESC")

  scope :alive, where(deleted: false)


  # Location
  include Geo::Model
  validates :location, presence: true
end
