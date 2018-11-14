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
#  push_token             :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_base64_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum gender: { male: 0, female: 1, other: 2 }

  has_many :spots, dependent: :destroy
  has_many :first_matches, class_name: 'Match', foreign_key: 'first_user_id', dependent: :destroy
  has_many :second_matches, class_name: 'Match', foreign_key: 'second_user_id', dependent: :destroy
  has_many :user_conversations
  has_many :conversations, through: :user_conversations, dependent: :destroy

  validates :name, :gender, presence: true

  after_create :send_welcome_mail

  serialize :push_token, Array

  def matches
    first_matches << second_matches
  end

  def self.from_provider(provider, user_profile)
    where(provider: provider, uid: user_profile[:id]).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.name = "#{user_profile[:first_name]} #{user_profile[:last_name]}"
      user.assign_attributes user_profile.except('id', 'first_name', 'last_name')
    end
  end

  private

  def send_welcome_mail
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
