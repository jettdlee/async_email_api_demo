class UserValidationJob < ApplicationJob
  queue_as :user_validation

  def perform(upload_id, data)
    upload = Upload.find(upload_id)
    return unless data
    user = User.new(name: row_data['name'], email: row_data['email'])
    unless user.validate
      upload.details << {
        name: user.name,
        email: user.email,
        error: user.error
      }
      upload.increment!(:failed_records)
    end
    upload.increment!(:processed_records)
    upload.save!
  end
end
