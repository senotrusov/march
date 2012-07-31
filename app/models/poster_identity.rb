
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


class PosterIdentity < ActiveRecord::Base
  # Associations
  belongs_to :poster, counter_cache: true
  belongs_to :document, counter_cache: true

  has_many :documents
  has_many :sections
  has_many :section_versions
  has_many :paragraphs


  PK_SEQUENCE_NAME = connection.pk_and_sequence_for(table_name).last
  def self.next_id
    connection.select_value("SELECT nextval('#{PK_SEQUENCE_NAME}');").to_i
  end
end
