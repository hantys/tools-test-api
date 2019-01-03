require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }

  before {host! 'api.rails.test'}
  describe 'Get /users/:id' do
    before do
      headers = { 'Accept' => 'application/json' }
      get "/v1//users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'return the user' do
        user_response = JSON.parse(response.body)
        expect(user_response['id']).to  eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to  have_http_status(200)
      end

    end

    context 'when the header invalid' do
      headers = { 'Accept' => 'application/asdasd' }
      # get '/v1//users/#{user_id}', params: {}, headers: headers

      it 'returns status code 404' do
        expect(response).to  have_http_status(404)
      end
    end

    context 'when the user invalid' do
      let(:user_id) { 9999 }

      it 'returns status code 404' do
        expect(response).to  have_http_status(404)
      end
    end
  end
end
