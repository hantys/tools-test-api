# spec/integration/users_spec.rb
require 'swagger_helper'

describe 'Users API', type: :request, capture_examples: true do
  before {host! "api.rails.test"}

  path '/v1/users/{id}' do
    get(summary: 'Retrieves a user') do
      tags 'Users'
      produces 'application/json'
      parameter id: :id, in: :path, type: :integer


      response(200, description: 'Return the selected user') do
        schema type: :object,
          properties: {
            id: { type: :integer  },
            email: { type: :string  },
            password: { type: :string  },
            password_confirmation: { type: :string  }
          },
          required: [ 'id', 'email', 'password', 'password_confirmation' ]
        let(:user_1) do
          FactoryBot.create(:user)
        end
        let(:id) { user_1.id }
        # run_test!
      end

      response(404, description: 'User not found') do
        let(:id) { 999 }
        # run_test!
      end

      response(406, description: 'unsupported accept header') do
        let(:'Accept') { 'application/foo' }
        # run_test!
      end
    end
  end
end