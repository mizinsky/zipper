# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'File Upload, Encryption, and Download Flow', type: :request do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload('test_file.txt', 'text/plain') }

  it 'performs the entire file process' do
    # Login#create
    post '/api/login', params: { user: { email: user.email, password: user.password } }
    expect(response).to have_http_status(:ok)
    token = JSON.parse(response.body)['token']
    expect(token).to be_present

    # Files#create
    post '/api/files',
         params: { file: },
         headers: { 'Authorization' => "Bearer #{token}" }
    expect(response).to have_http_status(:created)
    upload_response = JSON.parse(response.body)
    expect(upload_response['url']).to be_present
    expect(upload_response['password']).to be_present
    expect(upload_response['message']).to match(/uploaded and archived with password successfully/)

    # Files#index
    get '/api/files', headers: { 'Authorization' => "Bearer #{token}" }
    expect(response).to have_http_status(:ok)
    files_response = JSON.parse(response.body)
    expect(files_response).to be_an_instance_of(Array)
    file_info = files_response.find { |f| f['filename'] == 'test_file.txt.zip' }
    expect(file_info).to be_present
    attached_file = user.files.last
    expect(file_info['url']).to eq(rails_blob_url(attached_file))

    # Download file and decrypt
    file_data = ActiveStorage::Blob.service.download(attached_file.blob.key)
    io_file_data = StringIO.new(file_data)
    decrypter = Zip::TraditionalDecrypter.new(upload_response['password'])

    Zip::InputStream.open(io_file_data, decrypter:) do |io|
      entry = io.get_next_entry
      expect(io.read).to eq(file.read)
      expect(entry.name).to eq(file.original_filename)
    end
  end
end
