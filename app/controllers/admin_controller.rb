class AdminController < ApplicationController
  before_filter :admin_login_required

  def index
    redirect_to admin_games_path
  end

end
