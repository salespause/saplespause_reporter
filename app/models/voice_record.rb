class VoiceRecord < ApplicationRecord
  validates :text, presence: true

  has_many :words, :class_name => 'WordRecord'
end
