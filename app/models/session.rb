class Session < ApplicationRecord
  belongs_to :user

  before_create -> { _1.id = SecureRandom.uuid_v7 unless _1.id }
end
