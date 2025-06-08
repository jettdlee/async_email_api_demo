class Upload < ApplicationRecord
  include ActiveModel::Serializers::JSON
  attr_accessor :upload_id, :total_records, :processed_records, :failed_records, :details

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
