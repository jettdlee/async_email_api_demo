class StatusController < ApplicationController
  def show
    begin
      upload = Upload.find(params[:id])
      unless upload
        return render json: { error: "Upload not found" }, status: :not_found
      end

      render json: upload, serializer: upload.progress == 100 ? UploadSerializer : UploadProgressSerializer
    rescue => e
      render json: { error: "Failed to fetch status: #{e.message}" }, status: :internal_server_error
    end
  end
end
