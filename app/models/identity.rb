
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


class Identity < ActiveRecord::Base
  # Associations
  belongs_to :poster
  belongs_to :document, counter_cache: true

  has_many :documents
  has_many :sections
  has_many :paragraphs


  NEXTVAL = "SELECT nextval('#{connection.pk_and_sequence_for(table_name).last}');"
  def self.next_id
    connection.select_value(NEXTVAL).to_i
  end
  

  module Cache
    def assign_identity identity, addr
      self.identity            = identity
      self.identity_document   = identity.document
      self.identity_board_slug = identity.document.board.slug
      self.identity_name       = identity.name
      self.poster_addr         = addr
    end
  end
end
