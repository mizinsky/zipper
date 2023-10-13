# frozen_string_literal: true

module Api
  class FilesController < ApiController
    def create
      current_user.files.attach(params[:file])
      file = current_user.files.last

      render json: {
        filename: file.filename.to_s,
        link: rails_blob_url(file),
        password: 'TODO'
      }, status: :ok
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
