# frozen_string_literal: true

require 'zip'

class Archiver
  def self.zip(file, password)
    return unless file.is_a? ActionDispatch::Http::UploadedFile
    return unless password.is_a? String

    temp_file = Tempfile.new(['archive', '.zip'])

    begin
      enc = Zip::TraditionalEncrypter.new(password)

      Zip::OutputStream.open(temp_file.path, encrypter: enc) do |zipfile|
        zipfile.put_next_entry(file.original_filename)
        zipfile.write file.read
        file.rewind
      end
    rescue StandardError => e
      temp_file.unlink
      raise e
    end

    temp_file
  end
end
