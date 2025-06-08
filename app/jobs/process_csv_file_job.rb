class ProcessCsvFileJob < ApplicationJob
  def perform(upload_id, file_path)
    upload = Upload.find(upload_id)
    file = upload.file
  end
end
