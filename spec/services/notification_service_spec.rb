describe NotificationService do
  describe 'GET https://onesignal.com/api/v1/notifications' do
    describe '#notify' do
      let(:message) { I18n.t('api.notifications.new_match') }
      let(:push_token) { ['6392d91a-b206-4b7b-a620-cd68e32c3a76'] }
      let(:data) do
        {
          name: 'Paul',
          avatar: 'paul.gif',
          match_id: 1
        }
      end

      context 'with valid params' do
        let(:service) do
          NotificationService.new
        end

        it 'returns notification response' do
          create_notification_mock(200, create_notification_ok_body)
          json = service.notify(push_token, message, data)
          expect(JSON.parse(json.body)).to have_key('id')
          expect(JSON.parse(json.body)).to have_key('recipients')
        end
      end

      context 'when message is blank' do
        let(:blank_message) { '' }
        let(:service) do
          NotificationService.new
        end

        it 'returns error' do
          create_notification_mock(400, create_notification_bad_request_body)
          expect do
            service.notify(push_token, blank_message, data)
          end.to raise_error(OneSignal::OneSignalError)
        end
      end

      context 'when player_id is invalid' do
        let(:invalid_push_token) { ['invalid_id'] }
        let(:service) do
          NotificationService.new
        end

        it 'returns error message' do
          create_notification_mock(200, create_notification_invalid_player_id_body)
          json = service.notify(invalid_push_token, message, data)
          expect(JSON.parse(json.body)['errors']).to have_key('invalid_player_ids')
        end
      end

      context 'when players are not subscribed' do
        let(:service) do
          NotificationService.new
        end
        let(:params) do
          {
            app_id: ENV['PUSH_APP_ID'],
            contents: {
              en: message
            },
            include_player_ids: push_token,
            data: data
          }
        end

        it 'returns error message' do
          create_notification_mock(200, create_notification_no_subscribed_players_body)
          json = service.notify(push_token, message, data)
          expect(JSON.parse(json.body)['errors']).to include I18n.t('api.notifications.no_players')
        end
      end
    end
  end
end
