require 'rails_helper'

RSpec.describe CsvValidator do
  let(:valid_file) { fixture_file_upload("valid_users.csv", "text/csv") }
  let(:empty_file) { fixture_file_upload("empty.csv", "text/csv") }
  let(:invalid_header_file) { fixture_file_upload("missing_headers.csv", "text/csv") }
  let(:malformed_file) { fixture_file_upload("malformed.csv", "text/csv") }
  let(:non_csv_file) { fixture_file_upload("not_a_csv.pdf", "application/pdf") }

  describe "#validate!" do
    context "when file is nil" do
      it "raises MissingFileError" do
        expect { described_class.new(nil).validate! }.to raise_error(CsvValidator::MissingFileError, /Missing file/)
      end
    end

    context "when file format is invalid" do
      it "raises InvalidFormatError" do
        expect { described_class.new(non_csv_file).validate! }.to raise_error(CsvValidator::ValidationError, /Invalid file format/)
      end
    end

    context "when CSV is malformed" do
      it "raises ValidationError with 'Malformed CSV'" do
        expect { described_class.new(malformed_file).validate! }.to raise_error(CsvValidator::ValidationError, /Malformed CSV/)
      end
    end

    context "when CSV is empty" do
      it "raises ValidationError with 'CSV file is empty'" do
        expect { described_class.new(empty_file).validate! }.to raise_error(CsvValidator::ValidationError, /CSV file is empty/)
      end
    end

    context "when required headers are missing" do
      it "raises ValidationError with header message" do
        expect { described_class.new(invalid_header_file).validate! }.to raise_error(CsvValidator::ValidationError, /CSV headers must include/)
      end
    end

    context "when CSV is valid" do
      it "returns true" do
        result = described_class.new(valid_file).validate!
        expect(result).to eq(true)
      end
    end
  end
end

