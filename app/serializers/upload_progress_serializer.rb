class UploadProgressSerializer < ActiveModel::Serializer
  attributes :id, :progress

  def progress
    "#{object.progress}%"
  end
end
