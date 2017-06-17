class SessionsController < ApplicationController
  def create
    slack_client = Slack::Web::Client.new

    @auth_response = slack_client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: params[:code],
        redirect_uri: sessions_create_url
    )

    slack_client.token = @auth_response['access_token']
    @user_response = slack_client.users_info(user: @auth_response['user']['id'])
    load_and_verify_user

    if user_team.nil?
      redirect_to root_path, notice: 'You must add LinkBoy to your team before signing in!'
    elsif sign_in( @user || create_user )
      redirect_to links_path, notice: "Hi, #{current_user.first_name}!"
    else
      redirect_to root_path, notice: 'Whoops! There was a problem signing you in!'
    end
  end

  def destroy
    if sign_out
      redirect_to root_path, notice: 'Successfully signed out!'
    else
      redirect_to root_path, notice: 'Whoops!'
    end
  end

  private

  def load_and_verify_user
    @user = User.slack_find(user_attributes['id'], user_attributes['team_id'] )

    if @user.present? && @user.email.blank?
      @user.update(email: user_attributes['email'])
    end
  end

  def create_user
    User.create(user_params)
  end

  def user_attributes
    @user_response['user'].merge(@auth_response['user'])
  end

  def user_params
    {
        first_name: user_attributes['profile']['first_name'],
        last_name: user_attributes['profile']['last_name'],
        email: user_attributes['email'],
        slack_id: user_attributes['id'],
        team: user_team
    }
  end

  def user_team
    Team.find_by_team_id(user_attributes['team_id'])
  end
end
