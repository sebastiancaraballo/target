require 'rails_helper'
require 'faker'

shared_examples 'unsuccessful response' do
  it 'does not return a successful response' do
    post user_registration_path, params: params, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

describe 'POST api/v1/users', type: :request do
  let(:user) { User.last }

  describe 'POST create' do
    let(:params) do
      {
        user: attributes_for(:user)
      }
    end

    it 'returns a succesful response' do
      post user_registration_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'creates the user' do
      expect do
        post user_registration_path, params: params, as: :json
      end.to change(User, :count).by(1)
    end

    it 'returns the user' do
      post user_registration_path, params: params, as: :json
      expect(json[:user]).to include_json(
        id: user.id,
        email: user.email,
        name: user.name,
        gender: user.gender
      )
    end

    context 'when email is not correct' do
      let(:params) do
        {
          user: attributes_for(:user, email: 'invalid_email')
        }
      end

      it 'does not create a user' do
        expect do
          post user_registration_path, params: params, as: :json
        end.not_to change(User, :count)
      end

      it_behaves_like 'unsuccessful response'
    end

    context 'when the password is incorrect' do
      let(:new_user) { User.find_by_email(params[:user][:email]) }
      let(:params) do
        {
          user: attributes_for(:user, password: 'short', password_confirmation: 'short')
        }
      end
      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to be_nil
      end

      it_behaves_like 'unsuccessful response'
    end

    context 'when passwords do not match' do
      let(:new_user) { User.find_by_email(params[:user][:email]) }
      let(:params) do
        {
          user: attributes_for(:user, password: 'shouldmatch', password_confirmation: 'dontmatch')
        }
      end

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json
        expect(new_user).to be_nil
      end

      it_behaves_like 'unsuccessful response'
    end

    context 'when name is blank' do
      let(:new_user) { User.find_by_email(params[:user][:email]) }
      let(:params) do
        {
          user: attributes_for(:user, name: '')
        }
      end

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json
        expect(new_user).to be_nil
      end

      it_behaves_like 'unsuccessful response'
    end

    context 'when gender is not valid' do
      let(:new_user) { User.find_by_email(params[:user][:email]) }

      it 'does not create a user' do
        params[:user][:gender] = 'abc'
        expect(new_user).to be_nil
      end
    end
  end
end
