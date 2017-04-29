class CapturedImage < ApplicationRecord
  mount_uploader :content, FaceImageUploader

  validates :content, presence: true
end
