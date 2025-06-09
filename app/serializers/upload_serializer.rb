class UploadSerializer < ActiveModel::Serializer
  attributes :id, :total_records, :processed_records, :failed_records, :details

  def total_records
    object.progress_cache["totalRecords"]
  end

  def failed_records
    object.progress_cache["failedRecords"]
  end

  def processed_records
    object.progress_cache["processedRecords"]
  end

  def details
    object.errors_cache
  end
end
