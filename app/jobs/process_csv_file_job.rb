class ProcessCsvFileJob < ApplicationJob
  def perform(upload_id, file_path)
    upload = Upload.find(upload_id)
    file = upload.file
    return unless file.attached?
    file.open do |f|
      CSV.foreach(f, headers: true) do |row|
        upload.increment!(:total_records)
        EmailValidationJob.perform_later(upload.id, row.to_h)
      end
    end
  end
end
