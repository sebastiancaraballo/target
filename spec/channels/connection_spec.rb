require 'rails_helper'

describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }

  it 'successfully connects' do
    connect '/cable', headers: auth_headers

    expect(connection.current_user).to eq user
  end
end
