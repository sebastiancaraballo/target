# == Schema Information
#
# Table name: topics
#
#  id    :integer          not null, primary key
#  label :string           not null
#

require 'rails_helper'
describe Topic, type: :model do
  describe 'validations' do
    subject(:topic) { build :topic }
    it { is_expected.to validate_presence_of(:label) }
  end

  describe 'associations' do
    it { should have_many(:spots) }
  end
end
