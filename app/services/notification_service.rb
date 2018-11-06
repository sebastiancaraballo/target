class NotificationService
  include ActiveModel::Validations

  def initialize
    OneSignal::OneSignal.api_key = ENV['PUSH_API_KEY']
  end

  def notify(push_token, message, data)
    @push_token = push_token
    @message = message
    @data = data
    OneSignal::Notification.create(params: params)
  end

  private

  def params
    {
      app_id: ENV['PUSH_APP_ID'],
      contents: {
        en: @message
      },
      include_player_ids: @push_token,
      data: @data
    }
  end
end
