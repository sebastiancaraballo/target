module Api
  module V1
    class MessagesController < ApiController
      helper_method :conversation
      after_action :mark_messages_as_read, only: :index

      def index
        @messages = conversation.messages
      end

      private

      def conversation
        @conversation ||= current_user.conversations.find(params[:conversation_id])
      end

      def mark_messages_as_read
        conversation.reset_unread_messages(current_user)
      end
    end
  end
end
