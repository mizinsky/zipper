# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/files', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/files' do
    get 'Retrieves files' do
      tags 'Files'
      produces 'application/json'
      security [bearer: []]

      response '200', 'ok' do
        run_test!
      end
    end

    post 'Creates a file' do
      tags 'Files'
      consumes 'multipart/form-data'
      parameter name: :file, in: :formData, type: :file, required: true, description: 'File to be uploaded'
      security [bearer: []]

      response '201', 'created' do
        let(:file) { fixture_file_upload('test_file.txt', 'text/plain') }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to match(/uploaded and archived with password successfully/)
        end
      end

      response '422', 'invalid request' do
        let(:file) { nil }
        run_test!
      end
    end
  end
end
