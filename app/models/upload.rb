class Upload < ApplicationRecord
  include ActiveModel::Serializers::JSON

  has_one_attached :file

  def attributes
    {
      "uploadId": upload_id,
      "progress": progress,
      "totalRecords": total_records,
      "processedRecords": processed_records,
      "failedRecords": failed_records,
      "details": details
    }
  end

  private

  def progress
    percent = (processed_records.to_f / total_records * 100).to_i
    "#{percent}%"
  end
end
