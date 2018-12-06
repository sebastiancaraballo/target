module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      include Api::Concerns::ActAsApiRequest

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :name, :gender)
      end

      def render_create_success
        render :show
      end
    end
  end
end
