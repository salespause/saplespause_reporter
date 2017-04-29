class BlackList < ApplicationRecord

  has_many :face_images

  validates :name, presence: true
  validates :home_id, presence: true
end
