module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      verified_user = User.find_by(email: uid)
      if verified_user.valid_token?(token, client)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def token
      request.headers['access-token']
    end

    def client
      request.headers['client']
    end

    def uid
      request.headers['uid']
    end
  end
end
