class TeamRegistrar
  def initialize(current_user, code)
    @slack_client = Slack::Web::Client.new
    @current_user = current_user
    @code = code
  end

  def perform
    authorize_client
    validate_or_create_team
    start_server_instance
  end

  def self.perform(code, current_user)
    new(current_user, code).perform
  end

  def authorize_client
    @client_data = @slack_client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: @code
    )
  end

  def validate_or_create_team
    token = @client_data['bot']['bot_access_token']
    @team = Team.where(token: token).first
    @team ||= Team.where(team_id: @client_data['team_id']).first

    if @team && !@team.active?
      @team.activate!(token)
    elsif @team
      raise Slack::Web::Api::Error, "Team #{@team.name} is already registered."
    else
      @team = Team.create!(
          token: token,
          team_id: @client_data['team_id'],
          name: @client_data['team_name']
      )
    end
  end

  def update_current_user_team_if_blank
    if @current_user.present? && @current_user.team.nil?
      @current_user.update(team: @team)
    end
  end

  def start_server_instance
    SlackRubyBotServer::Service.instance.create!(@team)
  end
end
