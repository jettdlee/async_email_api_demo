class UploadsController < ApplicationController
  def create
    file = params[:file]
    begin
      CsvValidator.new(file).validate!
    rescue CsvValidator::MissingFileError => e
      return render json: { error: e.message }, status: :bad_request
    rescue CsvValidator::ValidationError => e
      return render json: { error: e.message }, status: :unprocessable_entity
    end

    upload = ProcessCsvService.new(file).call
    render json: { uploadId: upload.id, message: 'File uploaded successfully. Processing started.' }, status: :accepted
  end
end
