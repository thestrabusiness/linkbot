class TeamMemberRegistrar
  attr_accessor :team_id, :user_attributes, :slack_client, :members_list

  def initialize(team_id)
    @team_id = team_id
    @user_attributes = {}
    @slack_client = Slack::Web::Client.new
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
          team_id: team_id,
          first_name: user.profile.first_name,
          last_name: user.profile.last_name
      }
    end
  end

  def create_users
    user_attributes.each do |attributes|
      User.create(attributes.last)
    end
  end
end
