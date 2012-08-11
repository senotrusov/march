#  Copyright 2006-2012 Stanislav Senotrusov <senotrusov@gmail.com>
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


class HashWithIndifferentAccess
  def checkbox! *keys
    keys.each do |key|
      self[key] = (self[key] == "1" || self[key] == "true") ? true : false
    end
  end

  def extract_array key
    self.delete(key).tap do |result|
      raise "#{key.to_s.titleize} (if submitted) must be in Array form" unless result.kind_of?(Array) || result.nil?
    end
  end

  def require_hash key
    raise "#{key.to_s.titleize} must be submitted" unless self[key].kind_of?(Hash)
  end
end
