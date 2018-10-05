module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      include Api::Concerns::ActAsApiRequest
    end
  end
end
