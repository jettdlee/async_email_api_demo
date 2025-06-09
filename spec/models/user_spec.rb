require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validate" do
    it "returns true for a valid user" do
      user = User.new(name: "Alice", email: "alice@example.com")
      result = user.validate.value
      expect(result).to be true
    end

    it "returns false with invalid email" do
      user = User.new(name: "Bob", email: "invalid-email")
      result = user.validate.value
      expect(result).to be false
      expect(user.errors[:email]).to include("is invalid")
    end

    it "returns false when email is missing" do
      user = User.new(name: "NoEmail")
      result = user.validate.value
      expect(result).to be false
      expect(user.errors[:email]).to include("can't be blank")
    end
  end
end
