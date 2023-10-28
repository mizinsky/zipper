# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArchiveService, type: :service do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload('test_file.txt', 'text/plain') }
  let(:url_generator) do
    proc { |file|
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    }
  end

  describe '.create_archive' do
    context 'when the archiving process is successful' do
      subject { ArchiveService.create_archive(file, user, url_generator) }

      it 'attaches the archived file to the user' do
        expect { subject }.to change(ActiveStorage::Attachment, :count).by(1)
        expect(user.files.last.filename.to_s).to eq('test_file.txt.zip')
      end

      it 'returns the file information' do
        result = subject
        expect(result).to include(
          message: match(/uploaded and archived with password successfully/),
          url: match(%r{rails/active_storage/blobs/.*}),
          password: be_present
        )
      end
    end

    context 'when the archiving process fails' do
      subject { ArchiveService.create_archive(nil, user, url_generator) }

      it 'does not attach a file and returns nil' do
        expect { subject }.not_to change(ActiveStorage::Attachment, :count)
        expect(subject).to be_nil
      end
    end
  end
end
