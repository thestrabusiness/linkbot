class UserCreator
  attr_accessor :slack_user_id, :slack_team_id, :slack_client

  def initialize(slack_user_id, slack_team_id)
    @slack_team_id = slack_team_id
    @slack_user_id = slack_user_id
    @slack_client = Slack::Web::Client.new(token: team.token)
  end

  def perform
    user = slack_client.users_info(user: slack_user_id)

    User.create(
        slack_id: user.id,
        team_id: team.id,
        first_name: user.profile.first_name,
        last_name: user.profile.last_name
    )
  end

  def team
    @team ||= Team.find_by_team_id(slack_team_id)
  end

  def self.perform(slack_user_id, slack_team_id)
    new(slack_user_id, slack_team_id).perform
  end
end
