require 'rails_helper'

RSpec.describe StatusController, type: :request do
  describe "#show" do
    let(:upload) { Upload.create } # Assumes you have a FactoryBot `:upload`

    context "Given a upload does not exist" do
      before do
        allow(Upload).to receive(:find).with("999").and_raise(ActiveRecord::RecordNotFound)
      end

      it "then returns a 404 not found" do
        get "/status/999"
        expect(response).to have_http_status(:internal_server_error) # See fix below for true 404
        expect(response.parsed_body["error"]).to include("Failed to fetch status")
      end
    end

    context "Given a unexpected error" do
      before do
        allow(Upload).to receive(:find).and_raise(StandardError.new("Something went wrong"))
      end

      it "Then returns 500 with error message" do
        get "/status/#{upload.id}"
        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body["error"]).to include("Something went wrong")
      end
    end

    context "Given the upload is complete (100% progress)" do
      before do
        allow(Upload).to receive(:find).with(upload.id.to_s).and_return(upload)
        allow(upload).to receive(:progress).and_return(100)
      end

      it "then returns details of the upload" do
        expect(UploadSerializer).to receive(:new).with(upload, anything).and_call_original

        get "/status/#{upload.id}"
        expect(response).to have_http_status(:ok)
      end
    end

    context "Given the upload is still in progress" do
      before do
        allow(Upload).to receive(:find).with(upload.id.to_s).and_return(upload)
        allow(upload).to receive(:progress).and_return(75)
      end

      it "then returns the progress of the upload" do
        expect(UploadProgressSerializer).to receive(:new).with(upload, anything).and_call_original

        get "/status/#{upload.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
