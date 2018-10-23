module Api
  module V1
    class MessagesController < ApiController
      helper_method :conversation

      def index
        @messages = conversation.messages
      end

      private

      def conversation
        @conversation ||= current_user.conversations.find(params[:conversation_id])
      end
    end
  end
end
