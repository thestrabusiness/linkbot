class SlackAccount < ActiveRecord::Base
  has_many :links
  belongs_to :user
  belongs_to :team
  has_and_belongs_to_many :tagged_links, class_name: 'Link', join_table: 'user_tags'

  validates :slack_id, uniqueness: :team

  def self.slack_find(slack_user_id, slack_team_id)
    where(slack_id: slack_user_id, team_id: slack_team_id).first
  end
end
