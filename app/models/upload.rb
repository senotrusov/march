
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


module Upload
  ROOT = Pathname.new(CarrierWave.root)
  DELETED = Rails.root + 'db' + 'deleted' + (Rails.env.development? ? 'dev' : '')

  def copy_image_attr source
    self.write_uploader(:image, source.image_identifier)
  end

  def copy_image_file source
    unless image_identifier.blank?
      store_dir = ROOT + image.store_dir
      FileUtils.remove_entry_secure(store_dir) if store_dir.exist?

      if !source.remove_image && !source.image_identifier.blank?
        store_dir.parent.mkpath
        FileUtils.cp_r(ROOT + source.image.store_dir, store_dir)
      end
    end
  end

  def move_image_to_deleted
    unless image_identifier.blank?
      if (ROOT + image.store_dir).exist?
        (DELETED + image.store_dir).parent.mkpath
        FileUtils.mv(ROOT + image.store_dir, DELETED + image.store_dir)
      end
    end
  end

end
