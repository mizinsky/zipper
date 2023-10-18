# frozen_string_literal: true

require 'zip'

module Api
  class FilesController < ApiController
    def create
      password = SecureRandom.hex(4)

      archive = Archiver.zip(params[:file], password)

      unless archive
        render json: { error: 'invalid request' }, status: :unprocessable_entity
        return
      end

      filename = params[:file].original_filename

      current_user.files.attach(io: File.open(archive.path), filename: "#{filename}.zip",
                                content_type: 'application/zip')

      archive.close
      archive.unlink

      render json: {
        message: "File '#{filename}' uploaded and archived with password successfully.",
        url: url_for(current_user.files.last),
        password:
      }, status: :created
    end

    def index
      files_info = current_user.files.map do |file|
        {
          filename: file.filename.to_s,
          url: rails_blob_url(file)
        }
      end

      render json: files_info
    end
  end
end
