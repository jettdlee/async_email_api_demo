class UserValidationJob < ApplicationJob
  queue_as :user_validation

  def perform(upload_id, data)
    upload = Upload.find(upload_id)
    return unless data
    user = User.new(name: data['name'], email: data['email'])
    unless user.validate
      error_details = {
        name: user.name,
        email: user.email,
        error: user.error
      }
      REDIS.rpush("#{upload.redis_key}:errors", error_details.to_json)
      REDIS.hincrby("#{upload.redis_key}:progress", "failedRecords", 1)
      Rails.logger.warn("Upload #{upload.id} - Validation failed for #{user.email}: #{user.error}")
    else
      Rails.logger.info("Upload #{upload.id} - Validation succeeded for #{user.email}")
    end
    REDIS.hincrby("#{upload.redis_key}:progress", "processedRecords", 1)
    upload.save!
  rescue => e
    Rails.logger.error("Upload #{upload_id} - Unexpected error: #{e.class} - #{e.message}")
    raise
  end

  private

  def progress_cache_json
    return @_progress_cache if defined?(@_progress_cache)
    @_progress_cache = JSON.parse($redis.get(redis_key))
  end
end
