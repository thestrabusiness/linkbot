class Link < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user_from, class_name: 'User'
  belongs_to :user_to, class_name: 'User'
  has_one :team, through: :user_from

  friendly_id :slug, use: :slugged
end
