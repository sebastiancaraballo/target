class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [64, 64]
  end

  version :normal do
    process resize_to_fit: [512, 512]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
