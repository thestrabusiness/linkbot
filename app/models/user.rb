class User < ActiveRecord::Base
  belongs_to :team
  has_many :tags
  has_and_belongs_to_many :tagged_links, class_name: 'Link', join_table: 'user_tags'

  validates :slack_id, presence: true, uniqueness: true

  def self.slack_find(slack_user_id, slack_team_id)
    joins(:team).where('users.slack_id': slack_user_id, 'teams.team_id': slack_team_id).take
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
