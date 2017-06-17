class User < ActiveRecord::Base
  has_many :tags
  belongs_to :active_team, class_name: 'Team'
  has_many :slack_accounts
  has_many :teams, through: :slack_accounts

  def full_name
    [first_name, last_name].join(' ')
  end
end
