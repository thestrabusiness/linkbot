class User < ActiveRecord::Base
  friendly_id :slug, use: :slugged

  validates :email, presence: true, uniqueness: true
end
