
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
    def attr_enumerable attr, values
      
      unless respond_to? :enumerable_attrs
        cattr_accessor :enumerable_attrs
        self.enumerable_attrs = {}
      end

      enumerable_attrs[attr] = values
      validates attr, inclusion: { in: values }
    end

    def options_for attr
      enumerable_attrs[attr].map {|value| [I18n.t("#{self.i18n_scope}.attributes.#{self.model_name.i18n_key}.#{attr}_values.#{value}"), value]}
    end
  end

  def options_for attr
    self.class.options_for attr
  end
end
