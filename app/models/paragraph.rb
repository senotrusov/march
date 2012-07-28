
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
  belongs_to :poster_identity
  belongs_to :poster_identity_document, class_name: "Document"
  belongs_to :section, counter_cache: true, touch: true

  # if line_id IS NULL, then paragraph does not have other instances
  has_many :instances, class_name: "Paragraph", foreign_key: "line_id", primary_key: "line_id"

  attr_accessible :image, :title, :url, :message

  # TODO
  def location?
    rand > 0.7
  end

  def lat
    51.833896
  end

  def lng
    107.587538
  end
end
