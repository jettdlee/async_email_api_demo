require "csv"

class CsvValidator
  class MissingFileError < StandardError; end
  class ValidationError < StandardError; end

  def initialize(file)
    @file = file
  end

  def validate!
    raise MissingFileError, "Missing file" if @file.nil?

    unless [ ".csv" ].include?(File.extname(@file.original_filename).downcase)
      raise ValidationError, "Invalid file format. Only CSV files are allowed."
    end

    begin
      csv = CSV.read(@file.tempfile, headers: true)
    rescue CSV::MalformedCSVError => e
      raise ValidationError, "Malformed CSV: #{e.message}"
    end

    raise ValidationError, "CSV file is empty" if csv.empty?

    headers = csv.headers.map(&:downcase)
    unless headers.include?("name") && headers.include?("email")
      raise ValidationError, "CSV headers must include 'name' and 'email'"
    end

    true
  end
end
