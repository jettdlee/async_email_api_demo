class User
  include ActiveModel::Model

  attr_accessor :name, :email
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def validate
    Concurrent::Promises.future do
      sleep(0.1)
      valid?
    end
  end

  def error
    errors.full_messages.first
  end
end
