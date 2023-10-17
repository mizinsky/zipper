# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Login', type: :request do
  path '/api/login' do
    post 'Create Token' do
      tags 'Login'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response '200', 'token received' do
        let(:created_user) { create(:user) }
        let(:user) { { user: { email: created_user.email, password: created_user.password } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
        end
      end

      response '401', 'unauthorized' do
        let(:user) { { user: { email: 'user@example.com', password: '' } } }
        run_test!
      end
    end
  end
end
