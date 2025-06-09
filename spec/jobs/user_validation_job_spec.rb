require 'rails_helper'

RSpec.describe UserValidationJob, type: :job do
  let(:upload) { Upload.create! } # Adjust attributes if needed
  let(:errors_key) { "#{upload.redis_key}:errors" }
  let(:progress_key) { "#{upload.redis_key}:progress" }

  before do
    REDIS.del(errors_key)
    REDIS.del(progress_key)
  end

  context "Given valid user data" do
    let(:data) { { 'name' => 'Valid User', 'email' => 'user@example.com' } }

    it "Then updates successful processed count" do
      described_class.perform_now(upload.id, data)
      expect(REDIS.hget(progress_key, "processedRecords").to_i).to eq(1)
      expect(REDIS.llen(errors_key)).to eq(0)
    end
  end

  context "Given the user data is invalid" do
    let(:data) { { 'name' => 'Invalid User', 'email' => 'invalid-email' } }

    it "then increments failed count and gives error details" do
      described_class.perform_now(upload.id, data)
      expect(REDIS.hget(progress_key, "processedRecords").to_i).to eq(1)
      expect(REDIS.hget(progress_key, "failedRecords").to_i).to eq(1)
      error = JSON.parse(REDIS.lrange(errors_key, 0, -1).first)
      expect(error["email"]).to eq("invalid-email")
      expect(error["error"]).to be_present
    end
  end

  context "Given a issue occurs" do
    let(:data) { { 'name' => 'Crash', 'email' => 'crash@example.com' } }

    before do
      allow(User).to receive(:new).and_raise(StandardError, "Test failure")
    end

    it "Then the error is raised" do
      expect { described_class.perform_now(upload.id, data) }.to raise_error(StandardError, "Test failure")
    end
  end
end

