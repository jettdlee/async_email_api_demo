class User
  include ActiveModel::Model

  attr_accessor :name, :email

  def validate
    sleep(0.1)
    valid?
  end

  def valid?
    email.present? && email.include?("@")
  end
end
