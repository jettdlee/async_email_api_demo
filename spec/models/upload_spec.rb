require 'rails_helper'

RSpec.describe Upload, type: :model do
  let(:upload) { Upload.create! } # Add required attributes if needed
  let(:redis_progress_key) { "#{upload.redis_key}:progress" }
  let(:redis_errors_key) { "#{upload.redis_key}:errors" }

  before do
    REDIS.del(redis_progress_key)
    REDIS.del(redis_errors_key)
  end

  describe "#progress" do
    it "calculates percentage progress" do
      REDIS.hset(redis_progress_key, "processedRecords", 3)
      REDIS.hset(redis_progress_key, "totalRecords", 6)
      expect(upload.progress).to eq(50)
    end
  end
end

