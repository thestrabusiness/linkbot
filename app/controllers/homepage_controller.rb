class HomepageController < ApplicationController
  def index
    if current_user
      redirect_to links_path
    else
      render :index
    end
  end
end
