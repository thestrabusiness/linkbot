class RegistrationController < ApplicationController
  def register
    TeamRegistrar.perform(params[:code])
    flash[:notice] = 'Team registered successfully!'
    render :success

  rescue Slack::Web::Api::Error => error
    if error.message.include?('already registered')
      redirect_to links_path, notice: "You've already registered that team! Here are your links!"
    else
    redirect_to dashboard_index_path, notice: error.message.humanize
    end
  end

  def success
  end
end
