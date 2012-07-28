
# reload!; Document.all.select{|m|m.image.present?}.each {|m| m.image.recreate_versions!}.length
# WARNING! recreate_versions! will recreate base image from itself thus the checksum will be changed.

class ImageUploader < CarrierWave::Uploader::Base

  # Include MiniMagick support
  include CarrierWave::MiniMagick
  include CarrierWave::Processing::MiniMagick

  # Storage to use for this uploader
  storage :file

  # Directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.name.tableize}/#{mounted_as}/#{model.image_identifier[0,3]}/#{model.id}"
  end

  # Process uploaded file
  process :strip
  process :resize_to_limit => [2000, 2000]

  version :thumb do
    process :resize_to_fill => [80, 80]
  end

  version :minithumb do
    process :resize_to_fill => [50, 50]
  end

  version :page do
    process :resize_to_fit => [250, 250]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  def filename
    model.image_identifier.present? && model.image_identifier || (@digest_filename ||= super && (digest + File.extname(super).downcase))
  end

  def digest
    Digest::SHA2.hexdigest(model.image.read)[0,32]
  end
end
