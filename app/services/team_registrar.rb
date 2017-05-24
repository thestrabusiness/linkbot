class TeamRegistrar
  def initialize
    @slack_client = Slack::Web::Client.new
  end

  def perform(code)
    authorize_client(code)
    validate_or_create_team
    start_server_instance
  end

  def self.perform(code)
    new.perform(code)
  end

  def authorize_client(code)
    @client_data = @slack_client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: code
    )
  end

  def validate_or_create_team
    token = @client_data['bot']['bot_access_token']
    @team = Team.where(token: token).first
    @team ||= Team.where(team_id: rc['team_id']).first

    if @team && !@team.active?
      @team.activate!(token)
    elsif @team
      raise Slack::Web::Api::Error, "Team #{@team.name} is already registered."
    else
      @team = Team.create!(
          token: token,
          team_id: rc['team_id'],
          name: rc['team_name']
      )
    end
  end

  def start_server_instance
    SlackRubyBotServer::Service.instance.create!(@team)
  end
end
