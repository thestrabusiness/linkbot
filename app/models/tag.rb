class Tag < ActiveRecord::Base
  belongs_to :slack_user, class_name: 'SlackAccount'
  belongs_to :team
  has_and_belongs_to_many :links

  validates :name, presence: true, uniqueness: :team
end
