class TeamMemberRegistrar
  attr_accessor :team_id, :user_attributes, :slack_client, :members_list

  def initialize(team_id)
    @team_id = team_id
    @user_attributes = {}
    @slack_client = Slack::Web::Client.new(token: team.token)
  end

  def perform
    get_members_list
    collect_user_attributes
    create_users
  end

  def self.perform(team_id)
    new(team_id).perform
  end

  def get_members_list
    @members_list = slack_client
                      .users_list
                      .members
                      .reject { |u| u.is_bot || u.id == "USLACKBOT" }
  end

  def collect_user_attributes
    members_list.each_with_index do |user, index|
      user_attributes["user#{index}".to_sym] = {
          slack_id: user.id,
          active_team_id: team_id,
          first_name: user.profile.first_name,
          last_name: user.profile.last_name,
          email: user.profile.email
      }
    end
  end

  def create_users
    ActiveRecord::Base.transaction do
      user_attributes.each do |attributes|

        user_attributes = attributes.last.except(:slack_id, :email)
        user_slack_id = attributes.last[:slack_id]
        user_email = attributes.last[:email]

        new_user = User.create(user_attributes)

        SlackAccount.create(
            slack_id: user_slack_id,
            email: user_email,
            user: new_user,
            team: team
        )
      end
    end

  true

  rescue ActiveRecord::Rollback
    false
  end

  def team
    @team ||= Team.find(team_id)
  end
end
