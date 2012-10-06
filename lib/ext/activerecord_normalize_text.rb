
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


class ActiveRecord::Base
  class << self

    def normalize_text *attrs
      before_validation do |model|
        attrs.each do |attr|
          if string = model.__send__(attr)

            string = string.strip.gsub(/[\s&&[^\n]]+/, ' ').gsub(/[\s&&[^\n]]*\n[\s&&[^\n]]*/, "\n")
            string = nil if string.empty?

            model.__send__(:write_attribute, attr, string)
          end
        end
      end
    end
    
    # \r CR
    # \n LF
    # \r\n CRLF
    def normalize_newline *attrs
      before_validation do |model|
        attrs.each do |attr|
          if string = model.__send__(attr)
            model.__send__(:write_attribute, attr, string.gsub(/\r\n?/, "\n"))
          end
        end
      end
    end

  end
end
