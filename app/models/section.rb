
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
  belongs_to :poster_identity
  belongs_to :poster_identity_document, class_name: "Document"
  belongs_to :document, touch: true

  # if line_id IS NULL, then section does not have other instances
  has_many :instances, class_name: "Section", foreign_key: "line_id", primary_key: "line_id"
  has_many :section_versions
  has_many :paragraphs


  attr_accessible :is_versioned,
                  :is_sortable,
                  :is_public_writable,
                  :is_contributor_writable

  attr_accessible :image, :title
end
