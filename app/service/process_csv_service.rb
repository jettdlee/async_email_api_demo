require "csv"
class ProcessCsvService
  def initialize(file)
    @file = file
  end

  def call
    return unless @file.present?
    upload = Upload.create!
    upload.file.attach(@file)

    progress = REDIS.hmset("#{upload.redis_key}:progress", {
      "totalRecords": 0,
      "processedRecords": 0,
      "failedRecords": 0
    })

    CSV.foreach(@file.tempfile, headers: true) do |row|
      REDIS.hincrby("#{upload.redis_key}:progress", "totalRecords", 1)
      UserValidationJob.perform_later(upload.id, row.to_h)
    end
    upload
  end
end
