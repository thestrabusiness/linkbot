class LinksController < ApplicationController
  before_action :authenticate_user
  before_action :load_and_authorize_link, only: [:show, :destroy]

  def index
    @links = policy_scope(Link)
  end

  def show
    redirect_to @link.url
  end

  def destroy
    if @link.destroy
      redirect_to links_path, notice: 'Link deleted'
    else
      redirect_to links_path, error: 'There was a problem deleting the link'
    end
  end

  private

  def load_and_authorize_link
    @link = Link.find(params[:id])
    authorize @link
  end
end
