class FaceImage < ApplicationRecord
  belongs_to :black_list

  validates :image_url, presence: true
  validates :face_id, presence: true
  validates :black_list_id, presence: true
end
