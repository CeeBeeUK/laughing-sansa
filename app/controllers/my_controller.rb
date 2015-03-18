class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:profile, :profile_update, :game]
  respond_to :html

  def profile
  end

  def profile_update
    @user.update_column(:display_name, user_params[:display_name])
    redirect_to my_profile_path
  end

  def game
    @event = Event.find_by(year: params[:year])
    @pp = ParticipatingPlayer.find_by(player_id: current_user.id, event_id: @event.id)
    if @pp.nil?
      flash[:alert] = 'You have not joined this game'
      redirect_to root_path
    else
      respond_with(@pp)
    end
  end

private

  def load_user
    @user = User.find_by(email: current_user.email)
  end

  def user_params
    params.require(:user).permit(:display_name)
  end
end
