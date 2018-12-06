module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      include Api::Concerns::ActAsApiRequest

      def facebook
        user_profile = FacebookService.new(params[:access_token]).profile
        @resource = User.from_provider('facebook', user_profile)
        sign_in(:api_v1_user, @resource)
        response.headers.merge!(@resource.create_new_auth_token)
        render_create_success
      rescue ActiveRecord::RecordNotUnique
        render json: { error: I18n.t('api.errors.not_unique_user') }, status: :bad_request
      end

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      private

      def render_create_success
        render :show
      end
    end
  end
end
