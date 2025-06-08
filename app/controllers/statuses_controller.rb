class StatusesController < ApplicationController
  def show
    upload = Upload.find_by(upload_id: params[:upload_id])
    unless upload
      return render json: { error: "Upload not found" }, status: :not_found
    end

    render json: upload.serializable_hash
  end
end
