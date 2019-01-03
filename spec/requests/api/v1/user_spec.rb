require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:base_url) { "/v1/users" }

  before {host! 'api.rails.test'}

  describe 'Get /users/:id' do
    before do
      headers = { 'Accept' => 'application/json' }
      get "#{base_url}/#{user_id}", params: {}, headers: headers
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

    context 'when the user invalid' do
      let(:user_id) { 9999 }

      it 'returns status code 404' do
        expect(response).to  have_http_status(404)
      end
    end

    context 'when the header invalid' do
      before do
        headers = { 'Accept' => 'application/asdasd' }
        get "#{base_url}/#{user_id}", params: {}, headers: headers
      end

      it 'returns status code 406' do
        expect(response).to  have_http_status(406)
      end
    end

  end

  describe "POST /users" do

    before do
      headers = { 'Accept' => 'application/json' }
      post "#{base_url}/", params: {user: user_params}, headers: headers
    end

    context "when the resquest params are valid" do
      let(:user_params) { attributes_for(:user) }

      it "return status code 201" do
        expect(response).to  have_http_status(201)
      end

      it "return json data for the created user" do
        user_response = JSON.parse(response.body)
        expect(user_response['email']).to  eq(user_params[:email])
      end
    end

    context "when the request params are invalid" do
      let(:user_params) { attributes_for(:user, email: 'invalid@') }

      it "return the json data for the errors" do
        user_response = JSON.parse(response.body)
        expect(user_response).to  have_key('errors')
        
      end
      
      
    end
    
  end

end
