CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.fog_provider = 'fog/aws'
    config.fog_credentials =
      { provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_ID'],
        aws_secret_access_key: ENV['AWS_ACCESS_SECRET_KEY'],
        region: ENV['AWS_REGION'] }
    config.storage = :fog
    config.fog_directory = ENV['AWS_BUCKET_NAME']
    config.fog_public = false
  end
end
