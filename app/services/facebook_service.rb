class FacebookService
  ATTRIBUTES = %w[email first_name last_name gender].freeze

  def initialize(access_token)
    @access_token = access_token
  end

  def profile
    fb_attributes = client.get_object("me?fields=#{ATTRIBUTES.join(',')}")
    fb_attributes.with_indifferent_access
  end

  private

  def client
    @client ||= Koala::Facebook::API.new(@access_token)
  end
end
