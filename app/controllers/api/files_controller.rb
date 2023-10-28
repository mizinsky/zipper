# frozen_string_literal: true

require 'zip'

module Api
  class FilesController < ApiController
    def create
      url_generator = -> (file) { url_for(file) }
      result = ArchiveService.create_archive(params[:file], current_user, url_generator)

      if result
        render json: result, status: :created
      else
        render json: { error: 'invalid request' }, status: :unprocessable_entity
      end
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
