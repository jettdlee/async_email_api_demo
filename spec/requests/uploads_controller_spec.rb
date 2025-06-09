require 'rails_helper'

RSpec.describe UploadsController, type: :request do
  describe "#create" do
    let(:valid_file) { fixture_file_upload("valid_users.csv", "text/csv") }

    context "Given no file is uploaded" do
      before do
        allow(CsvValidator).to receive(:new).and_raise(CsvValidator::MissingFileError, "Missing file")
      end

      it "then returns a 400 bad request" do
        post "/upload"
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body["error"]).to eq("Missing file")
      end
    end

    context "Given an invalid CSV is uploaded" do
      let(:invalid_file) { fixture_file_upload("invalid_users.csv", "text/csv") }
      let(:invalid_validator) { double("CsvValidator") }

      before do
        allow(CsvValidator).to receive(:new).and_return(invalid_validator)
        allow(invalid_validator).to receive(:validate!).and_raise(CsvValidator::ValidationError, "Malformed CSV")
      end

      it "Then returns a 422 unprocessable entity response, with Malformed error" do
        post "/upload", params: { file: invalid_file }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["error"]).to eq("Malformed CSV")
      end
    end

    context "Given connection issues with Redis" do
      before do
        allow(CsvValidator).to receive(:new).and_return(double(validate!: true))
        allow(ProcessCsvService).to receive_message_chain(:new, :call)
        allow(REDIS).to receive(:hmset).and_raise(Redis::CannotConnectError.new("Failed to connect"))
      end

      it "then returns 500 with redis error" do
        post "/upload", params: { file: valid_file }
        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body["error"]).to include("Internal server error")
      end
    end

    context "Given a valid CSV is uploaded" do
      let(:service_stub) { double("Upload", id: 123) }

      before do
        allow(CsvValidator).to receive(:new).and_return(double(validate!: true))
        allow(ProcessCsvService).to receive_message_chain(:new, :call).and_return(service_stub)
      end

      it "Then returns a 202 accepted and uploadId" do
        post "/upload", params: { file: valid_file }
        expect(response).to have_http_status(:accepted)
        expect(response.parsed_body["uploadId"]).to eq(123)
        expect(response.parsed_body["message"]).to eq("File uploaded successfully. Processing started.")
      end
    end
  end
end

