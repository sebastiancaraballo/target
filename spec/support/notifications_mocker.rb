def create_notification_mock(status, response_body)
  stub_request(:post, ENV['ONESIGNAL_NOTIFICATIONS_URL'])
    .with(
      headers: {
        'Authorization': "Basic #{ENV['PUSH_API_KEY']}",
        'Content-Type': 'application/json'
      }
    )
    .to_return(status: status, body: response_body)
end

def create_notification_ok_body
  "{\"id\":\"458dcec4-cf53-11e3-add2-000c2940e62c\",\"recipients\":\"1\"}"
end

def create_notification_bad_request_body
  "{\"errors\":\"[#{I18n.t('api.notifications.blank_message')}]\"}"
end

def create_notification_invalid_player_id_body
  "{\"errors\":{\"invalid_player_ids\":[\"invalid_id\"]}}"
end

def create_notification_no_subscribed_players_body
  "{\"id\":\"\",\"recipients\":0,\"errors\":[" \
  "\"#{I18n.t('api.notifications.no_players')}\"]}"
end
