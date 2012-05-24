
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
  belongs_to :poster, counter_cache: true
  belongs_to :poster_identity
  belongs_to :board, counter_cache: true, touch: true
  has_many :poster_identities
  has_many :sections

  attr_accessible :image, :title, :url, :message

  scope :eager,
    includes(:poster_identities).
    includes(:sections => [:instances, {:paragraphs => :instances}])
end
