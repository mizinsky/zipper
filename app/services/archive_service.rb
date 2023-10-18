# frozen_string_literal: true

class ArchiveService
  def self.create_archive(file, user, url_generator)
    password = SecureRandom.hex(4)
    archive = nil

    begin
      archive = Archiver.zip(file, password)

      return nil unless archive

      filename = file.original_filename

      user.files.attach(io: File.open(archive.path), filename: "#{filename}.zip", content_type: 'application/zip')

      {
        message: "File '#{filename}' uploaded and archived with password successfully.",
        url: url_generator.call(user.files.last),
        password:
      }
    rescue StandardError => e
      handle_error(e)
    ensure
      clean_tmp_files(archive)
    end
  end

  def self.clean_tmp_files(archive)
    return unless archive

    archive.close
    archive.unlink
  end

  def self.handle_error(error)
    Rails.logger.error("ArchiveService failed: #{error.message}")
    nil
  end
end
