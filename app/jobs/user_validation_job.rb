class UserValidationJob < ApplicationJob
  queue_as :email_validation

  def perform(upload_id, data)
    upload = Upload.find(upload_id)
    return
  end
end
