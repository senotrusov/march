
 # Copyright 2011-2012 Stanislav Senotrusov <stan@senotrusov.com>
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

module Geo
  mattr_accessor :config

  LAT_RANGE = -90..90
  LNG_RANGE = -180..180

  module Model
    def self.included(base)
      base.class_eval do
        attr_accessible :location
        validate        :is_location_correct

        attr_accessible :zoom
        before_save     :nilify_zoom_without_location
        validates       :zoom, numericality: {
          greater_than_or_equal_to: Geo.config[:min_zoom],
          less_than_or_equal_to:    Geo.config[:max_zoom],
          only_integer: true }, allow_blank: true
      end
    end

    def location
      @location || (lat && lng) && "#{lat} #{lng}"
    end

    def location= value
      @location = value

      if match = value.gsub(/[^-\d,\.\s]/ , ' ').gsub(/\s*[,\.]\s*/, '.').gsub(/-\s*/, '-').match(/^\s*(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s*$/)
        self.lat = match[1]
        self.lng = match[2]
      end
    end

    def location?
      lat? && lng?
    end

    def is_location_correct
      if @location.present?
        if lat && lng
          errors.add(:location, "latitude must be within #{Geo::LAT_RANGE} range") unless (Geo::LAT_RANGE).include?(lat)
          errors.add(:location, "longitude must be within #{Geo::LNG_RANGE} range") unless (Geo::LNG_RANGE).include?(lng)
          errors.add(:zoom, "can't be blank") unless zoom.present?
        else
          errors.add(:location, "must be well-formed")
        end
      end
    end

    def nilify_zoom_without_location
      self.zoom = nil unless lat && lng
    end
  end
end

if File.exists?(config_file = Rails.root + 'config' + 'geo.yml')
  if (yaml = YAML.load_file(config_file)).kind_of?(Hash)
    if (env = yaml[Rails.env]).kind_of?(Hash)
      Geo.config = env.with_indifferent_access
    else
      raise "#{config_file} hash does not contains key for current #{Rails.env} environment"
    end
  else
    raise "#{config_file} does not contains a Hash"
  end
end
