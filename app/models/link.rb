class Link < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User'
  belongs_to :user_to, class_name: 'User'
  has_one :team, through: :user_from

end
