class User < ActiveRecord::Base
  has_many :tags
  belongs_to :active_team, class_name: 'Team'
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :tagged_links, class_name: 'Link', join_table: 'user_tags'

  validates :slack_id, presence: true, uniqueness: :team

  def self.slack_find(slack_user_id, slack_team_id)
    joins(:teams).where(
        slack_id: slack_user_id,
        teams: { team_id: slack_team_id }
    ).take
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
