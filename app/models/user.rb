class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :username, with: -> { _1.strip.presence }
  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /\A\w+\z/ },
    length: { maximum: 20 }

  before_create -> { _1.id = SecureRandom.uuid_v7 unless _1.id }
end
