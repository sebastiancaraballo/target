# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  conversation_id :integer
#  sender_id       :integer          not null
#  content         :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_sender_id        (sender_id)
#

require 'rails_helper'

describe Message, type: :model do
  describe 'validations' do
    subject(:message) { build :message }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:sender).class_name('User') }
  end
end
