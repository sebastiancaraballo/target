require 'rails_helper'

describe 'PUT api/v1/users/:id', type: :request do
  let(:user)              { create(:user) }
  let(:new_email)         { 'test2@test.com' }
  let(:new_name)          { 'Test2' }
  let(:new_gender)        { 'female' }
  let(:image_data) do
    Base64.encode64(File.open(
                      File.join(
                        Rails.root, 'spec/assets/default-avatar.png'
                      ), &:read
                    ))
  end

  let(:image)             { "data:image/png;base64,#{image_data}" }
  let(:image_url)         { "/uploads/user/avatar/#{user.id}/" }
  let(:image_filename)    { 'avatar.png' }

  before do
    put api_v1_user_path(user), params: params, headers: auth_headers, as: :json
  end

  context 'with valid params' do
    let(:params) do
      {
        user: {
          email: new_email,
          name: new_name,
          gender: new_gender,
          avatar: image
        }
      }
    end

    it 'returns a succesful response' do
      expect(response).to have_http_status(:success)
    end

    it 'updates the user' do
      user.reload
      expect(user.email).to eq(new_email)
      expect(user.name).to eq(new_name)
      expect(user.gender).to eq(new_gender)
      expect(user.avatar.url).to eq(image_url + image_filename)
    end

    it 'returns the user' do
      expect(json[:user]).to include_json(
        id: user.id,
        email: new_email,
        name: new_name,
        gender: new_gender,
        avatar: {
          url: image_url + image_filename,
          thumb: {
            url: image_url + 'thumb_' + image_filename
          },
          normal: {
            url: image_url + 'normal_' + image_filename
          }
        }
      )
    end
  end

  context 'with invalid params' do
    let(:params) do
      {
        user: { email: 'invalid_email' }
      }
    end

    it 'does not return success' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'does not update the user' do
      expect { user.reload }.to_not change(user, :email)
    end
  end
end
