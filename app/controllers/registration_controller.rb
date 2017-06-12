class RegistrationController < ApplicationController
  def register
    TeamRegistrar.perform(params[:code], current_user)
    flash[:notice] = 'Team registered successfully!'
    redirect_to new_session_path,
                notice: 'Team Registered! Welcome to LinkBot!<br />Please sign in with your Slack account to see your links'.html_safe


  rescue Slack::Web::Api::Error => error
    if error.message.include?('already registered') && current_user
      redirect_to links_path,
                  notice: "You've already registered that team! Here are your links!"

    elsif error.message.include?('already registered') && !current_user
      redirect_to new_session_path,
                  notice: "You've already registered that team! Sign in to see your links!"

    else
      redirect_to homepage_index_path, notice: error.message.humanize
    end
  end
end
