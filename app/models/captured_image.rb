class CapturedImage < ApplicationRecord
  validates :content, presence: true
  mount_uploader :content, FaceImageUploader
end
