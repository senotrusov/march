
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


class Board < ActiveRecord::Base
  # Associations
  has_many :documents, inverse_of: :board, conditions: { deleted: false }


  # Attributes
  attr_accessible :slug

  validates :slug,
    length: { in: 1..columns_hash['slug'].limit },
    format: { with: /\A[a-zA-Z0-9\-]+\z/, message: "Only characters a-z, A-Z, 0-9 and '-' allowed" }


  # Scopes
  scope :ordered, order(ORDER = "slug")
end
