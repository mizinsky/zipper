# frozen_string_literal: true

require 'rails_helper'
require 'zip'

RSpec.describe Archiver, type: :lib do
  let(:filename) { 'test_file.txt' }
  let(:file) { fixture_file_upload(filename, 'text/plain') }
  let(:password) { 'securepassword' }

  describe '.zip' do
    subject(:zipped_file) { described_class.zip(file, password) }

    it 'creates a zip archive' do
      expect(zipped_file).to be_present
      expect(File.extname(zipped_file.path)).to eq('.zip')
    end

    it 'contains the correct file' do
      decrypter = Zip::TraditionalDecrypter.new(password)

      Zip::InputStream.open(zipped_file.path, decrypter:) do |io|
        entry = io.get_next_entry
        expect(io.read).to eq(file.read)
        expect(entry.name).to eq(filename)
      end
    end

    it 'is password-protected' do
      expect do
        Zip::InputStream.open(zipped_file.path) do |io|
          io.get_next_entry
          io.read
        end
      end.to raise_error(Zip::Error)
    end
  end
end
