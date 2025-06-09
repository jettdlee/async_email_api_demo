class Upload < ApplicationRecord
  has_one_attached :file

  def redis_key
    "upload:#{self.id}"
  end

  def progress
    return 0 if progress_cache["totalRecords"].to_f.zero?
    (progress_cache["processedRecords"].to_f / progress_cache["totalRecords"].to_f * 100).to_i
  end

  def progress_cache
    REDIS.hgetall("#{self.redis_key}:progress")
  end

  def errors_cache
    REDIS.lrange("#{self.redis_key}:errors", 0, -1).map { |e| JSON.parse(e) }
  end
end
