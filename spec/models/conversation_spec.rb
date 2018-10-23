# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_conversations_on_match_id  (match_id)
#

require 'rails_helper'

describe Conversation, type: :model do
  describe 'associations' do
    it { should belong_to(:match) }
    it { should have_many(:users).through(:user_conversations) }
    it { should have_many(:messages).dependent(:destroy) }
  end
end
