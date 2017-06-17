class SessionsController < ApplicationController
  def create
    get_user_auth_response(sessions_create_url)
    load_and_verify_user

    if user_team.nil?
      redirect_to root_path, notice: 'You must add LinkBoy to your team before signing in!'
    elsif sign_in( @user || create_user )
      redirect_to links_path, notice: "Hi, #{current_user.first_name}!"
    else
      redirect_to root_path, notice: 'Whoops! There was a problem signing you in!'
    end
  end

  def link
    get_user_auth_response(sessions_link_url)

    slack_account = SlackAccount.find_by_email(user_attributes['email'])

    if user_team.nil?
      redirect_to root_path, notice: 'You must add LinkBoy to your team before signing in with that account!'
    elsif slack_account.present? && slack_account.user == current_user
      current_user.update(active_team: slack_account.team)
      redirect_to links_path, notice: 'You\'ve already linked that account, here are your links.'
    elsif slack_account.present? && slack_account.user != current_user
      slack_account.update(user: current_user)
      current_user.update(active_team: slack_account.team)
      redirect_to links_path, notice: 'Account linked! Here\'s your team\'s dashboard.'
    elsif !slack_account.present?
      slack_account = SlackAccount.create(
                                user: current_user,
                                team: user_team,
                                slack_id: user_attributes['id'],
                                email: user_attributes['email']
      )

      current_user.update(active_team: slack_account.team)
      redirect_to links_path, notice: 'Account linked! Here\'s your team\'s dashboard.'
    else
      redirect_to links_path, notice: 'There was a problem signing in with your account.'
    end
  end

  def update
    team = Team.find(params[:team_id])

    if current_user.update(active_team: team)
      redirect_to links_path
    else
      redirect_to sessions_switch_user_path, notice: 'There was a problem switching teams!'
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
    @user = SlackAccount.slack_find(user_attributes['id'], user_team.id).user
  end

  def get_user_auth_response(redirect_uri)
    slack_client = Slack::Web::Client.new

    @auth_response = slack_client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: params[:code],
        redirect_uri: redirect_uri
    )

    slack_client.token = @auth_response['access_token']
    @user_response = slack_client.users_info(user: @auth_response['user']['id'])
  end

  def create_user
    UserCreator.perform(user_attributes['id'], user_attributes['team_id'], user_attributes['email'])
  end

  def user_attributes
    @user_response['user'].merge(@auth_response['user'])
  end

  def user_team
    Team.find_by_team_id(user_attributes['team_id'])
  end
end
