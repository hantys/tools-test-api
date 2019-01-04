require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:base_url) { "/v1/users" }
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => Mime[:json].to_s
    }
  end

  before {host! 'api.rails.test'}

  describe 'Get /users/:id' do
    before do
      get "#{base_url}/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'return the user' do
        expect(json_body[:id]).to  eq(user_id)
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
      let(:headers) do
        {
          'Accept' => 'application/xml',
          'Content-Type' => Mime[:json].to_s
        }
      end
      before do
        get "#{base_url}/#{user_id}", params: {}, headers: headers
      end
      it 'returns status code 406' do
        expect(response).to  have_http_status(406)
      end
    end

  end

  describe "POST /users" do

    before do
      post "#{base_url}/", params: {user: user_params}.to_json, headers: headers
    end

    context "when the resquest params are valid" do
      let(:user_params) { attributes_for(:user) }

      it "return status code 201" do
        expect(response).to  have_http_status(201)
      end

      it "return json data for the created user" do
        expect(json_body[:email]).to  eq(user_params[:email])
      end
    end

    context "when the request params are invalid" do
      let(:user_params) { attributes_for(:user, email: 'invalid@') }

      it "return the json data for the errors" do
        expect(json_body).to  have_key(:errors)
      end
    end
  end

  describe "PUT /users/id" do
    before do
      put "#{base_url}/#{user_id}", params: {user: user_params}.to_json, headers: headers
    end

    context "when the request params is valid" do
      let(:user_params) { {email: "teste_new_email@hotmail.com"} }

      it "return status code 200" do
        expect(response).to  have_http_status(200)
      end

      it "when the json data for the updated user" do
        expect(json_body[:email]).to  eq(user_params[:email])
      end
    end

    context "when the request params is invalid" do
      let(:user_params) { {email: "teste_new_email"} }

      it "return status code 422" do
        expect(response).to  have_http_status(422)
      end

      it "when the json data for the updated user" do
        expect(json_body).to have_key(:errors)
      end

    end
  end

  describe "DELETE /users/id" do
    before do
      delete "#{base_url}/#{user_id}", params: {}, headers: headers
    end

    it "return status code 204" do
      expect(response).to  have_http_status(204)
    end

    it "removes the user from database" do
      expect(User.find_by(id: user.id)).to  be_nil
    end
  end
end
