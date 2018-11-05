module Api
  module V1
    class UsersController < ApiController
      helper_method :user

      def show; end

      def update
        current_user.update!(user_params)
        render :show
      end

      private

      def user_params
        params.require(:user).permit(:email, :name, :gender, :avatar)
      end

      def user
        @user ||= User.find(params[:id])
      end
    end
  end
end
