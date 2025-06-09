class UserValidationJob < ApplicationJob
  queue_as :user_validation

  def perform(upload_id, data)
    upload = Upload.find(upload_id)
    return unless data
    user = User.new(name: data["name"], email: data["email"])
    unless user.validate.value
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
  rescue => e
    Rails.logger.error("Upload #{upload_id} - Unexpected error: #{e.class} - #{e.message}")
    raise
  end
end
