module Api
  module V1
    class ConversationsController < ApiController
      def create
        @conversation = current_user.conversations.create!(conversation_params)
      end

      def index
        @conversations = current_user.conversations
      end

      private

      def conversation_params
        params.require(:conversation).permit(:match_id)
      end
    end
  end
end
