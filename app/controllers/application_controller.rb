class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  def after_sign_in_path_for(user)
    game_in_progress = Event.latest_active.last
    if game_in_progress && game_in_progress.being_played_by?(user)
      my_game_path(game_in_progress)
    elsif game_in_progress && game_in_progress.can_be_joined_by?(user)
      game_join_path(game_in_progress)
    else
      root_path
    end
  end
end
