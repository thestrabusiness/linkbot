class UserCreator
  attr_accessor :slack_user_id, :slack_team_id, :slack_client, :user_email

  def self.perform(slack_user_id, slack_team_id, user_email)
    new(slack_user_id, slack_team_id, user_email).perform
  end

  def initialize(slack_user_id, slack_team_id, user_email)
    @user_email = user_email
    @slack_team_id = slack_team_id
    @slack_user_id = slack_user_id
    @slack_client = Slack::Web::Client.new(token: team.token)
  end

  def perform
    user = slack_client.users_info(user: slack_user_id).user

    new_user = User.create(
        first_name: user.profile.first_name,
        last_name: user.profile.last_name
    )

    SlackAccount.create(
        slack_id: user.id,
        email: user_email,
        team: team,
        user: new_user
    )

    new_user
  end

  def team
    @team ||= Team.find_by_team_id(slack_team_id)
  end
end
