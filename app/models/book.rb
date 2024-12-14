class Book < ApplicationRecord
  before_create -> { _1.id = SecureRandom.uuid_v7 unless _1.id }

  belongs_to :user

  validates :title, presence: true
  validates :author, presence: true
  validates :finish_date, presence: true
  validates :format, presence: true, inclusion: { in: [ "text", "audio", "video" ] }

  normalizes :title, :author, :location, with: -> { _1.strip.presence }
end
