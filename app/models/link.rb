class Link < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User'
  has_one :team, through: :user_from
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :tagged_users, class_name: 'User', join_table: 'user_tags'
  belongs_to :metadata

  delegate :title, to: :metadata, allow_nil: true
  delegate :domain, to: :metadata, allow_nil: true
  delegate :description, to: :metadata, allow_nil: true

  validates :url, :user_from, presence: true
end
