# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  gender                 :integer
#  avatar                 :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    subject(:user) { build(:user, email: 'email') }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:gender) }
    it 'is not valid without a valid gender' do
      expect { build(:user, gender: 'abc') }.to raise_error(ArgumentError)
    end
  end

  describe 'associations' do
    it { should have_many(:spots).dependent(:destroy) }
    it {
      should have_many(:first_matches)
        .class_name('Match')
        .with_foreign_key('first_user_id')
    }
    it {
      should have_many(:second_matches)
        .class_name('Match')
        .with_foreign_key('second_user_id')
    }
    it { should have_many(:conversations).through(:user_conversations) }
  end
end
