# == Schema Information
#
# Table name: topics
#
#  id    :integer          not null, primary key
#  label :string           not null
#

class Topic < ActiveRecord::Base
  validates :label, presence: true
end
