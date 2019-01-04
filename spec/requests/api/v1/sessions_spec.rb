require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  before {host! 'api.rails.test'}

  let(:user) { create(:user, password: "123456") }
  let(:base_url) { "/v1/sessions" }
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe "POST /sessions" do
    before do
      post "#{base_url}/", params: {session: credentials}.to_json, headers: headers
    end

    context "when the credentials are correct" do
      let(:credentials) {
        {
          email: user.email,
          password: "123456"
        }
      }
      it "return status code 200" do
        expect(response).to  have_http_status(200)
      end

      it "return json data for the user with auth token" do
        user.reload
        expect(json_body[:auth_token]).to  eq(user.auth_token)
      end
    end

    context "when the credentials are incorrect" do
      let(:credentials) {
        {
          email: user.email,
          password: "12345621"
        }
      }
      it "return status code 401" do
        expect(response).to  have_http_status(401)
      end

      it "return json data for the user with auth token" do
        expect(json_body).to  have_key(:errors)
      end
    end
  end

  describe "DELETE /sessions" do
    let(:auth_token) { user.auth_token } 
    before do
      delete "#{base_url}/#{auth_token}", params: {}, headers: headers
    end

    it "return status code 204" do
      expect(response).to  have_http_status(204)
    end

    it "change the user auth token" do
      expect(User.find_by(auth_token: auth_token)).to  be_nil
    end

  end
end