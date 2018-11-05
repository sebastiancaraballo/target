require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user)      { create(:user) }
  let(:uploader)  { AvatarUploader.new(user, :avatar) }

  before do
    AvatarUploader.enable_processing = true
    File.open('spec/assets/default-avatar.png') { |f| uploader.store!(f) }
  end

  after do
    AvatarUploader.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it 'scales down avatar to be exactly 64 by 64 pixels' do
      expect(uploader.thumb).to have_dimensions(64, 64)
    end

    it 'has the correct format' do
      expect(uploader).to be_format('png')
    end
  end

  context 'the normal version' do
    it 'scales down avatar to be exactly 512 by 512 pixels' do
      expect(uploader.normal).to have_dimensions(512, 512)
    end

    it 'has the correct format' do
      expect(uploader).to be_format('png')
    end
  end
end
