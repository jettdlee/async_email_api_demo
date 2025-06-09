describe CsvUploadValidator do
  let(:valid_file) { fixture_file_upload("valid.csv", "text/csv") }
  let(:invalid_file) { fixture_file_upload("invalid.csv", "text/csv") }

  it "is valid with a correct CSV" do
    validator = CsvUploadValidator.new(valid_file)
    expect(validator.valid?).to be true
  end

  it "is invalid with missing headers" do
    validator = CsvUploadValidator.new(invalid_file)
    expect(validator.valid?).to be false
    expect(validator.errors).to include(/headers/)
  end
end
