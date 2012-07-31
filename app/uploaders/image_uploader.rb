
# reload!; [Document, Section, Paragraph].each {|c| c.all.select{|m|m.image.present?}.each {|m| m.image.recreate_versions!} }; nil
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

  version(:normal) { process :resize_to_fit  => [250, 250] }
  version(:small)  { process :resize_to_fill => [150, 150] }
  version(:mini)   { process :resize_to_fill => [80, 80] }
  version(:tiny)   { process :resize_to_fill => [50, 50] }

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
