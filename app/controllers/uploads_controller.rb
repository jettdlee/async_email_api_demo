class UploadsController < ApplicationController
  def create
    file = params[:file]
    unless file
      return render json: { error: "No file Uploaded" }, status: :bad_request
    end

    upload = Upload.create!(upload_id: SecureRandom.uuid)
    ProcessCsvFileJob.perform_later(upload.id, file.tempfile.path)
    render json: { uploadId: upload.upload_id, message: 'File uploaded successfully. Processing started.' }, status: :accepted
  end

  private

  def upload_params
    params.require(:file)
  end
end
