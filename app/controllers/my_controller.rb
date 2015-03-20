class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:profile, :profile_update, :game]
  before_action :load_pp, only: [:game]
  respond_to :html

  def profile
  end

  def profile_update
    @user.update_column(:display_name, user_params[:display_name])
    redirect_to my_profile_path
  end

  def game
    return respond_with(@pp) if @pp
    if @event.active?
      redirect_to game_sign_up_path(@event)
    else
      flash[:alert] = 'This game cannot be joined'
      redirect_to root_path
    end
  end

private

  def load_user
    @user = User.find_by(email: current_user.email)
  end

  def load_pp
    @event = Event.find_by(year: params[:year])
    @pp = EventPlayer.find_by(player_id: current_user.id, event_id: @event.id)
  end

  def user_params
    params.require(:user).permit(:display_name)
  end
end
