class Link < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User'
  has_one :team, through: :user_from
  has_and_belongs_to_many :tagged_users, class_name: 'User', join_table: 'user_tags'
end
