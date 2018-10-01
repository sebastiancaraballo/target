require 'rails_helper'

describe 'GET api/v1/topics', type: :request do
  let(:user)            { create(:user) }
  let!(:created_topics) { create_list(:topic, 3) }

  it 'returns topics' do
    get api_v1_topics_path, headers: auth_headers, as: :json
    created_topics.each do |topic|
      expect(json).to include_json(
        topics: UnorderedArray(id: topic.id, label: topic.label)
      )
    end
  end

  it 'does return a successful response' do
    get api_v1_topics_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end
end
