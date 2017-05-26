class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: :slugged

  validates :email, presence: true, uniqueness: true
end
