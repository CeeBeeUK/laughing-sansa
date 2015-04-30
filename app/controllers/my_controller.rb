class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:profile, :profile_update, :game]
  before_action :load_pp, only: [:game]
  before_action :load_eps, only: [:game, :score, :score_create]
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

  def score
  end

  def score_create
    if @eps.update(score_params)
      reset_event_attribute('fattest', @eps)
      reset_event_attribute('wackiest', @eps)
      reset_event_attribute('best_wail', @eps)
      redirect_to my_game_path(@eps.event)
    else
      render :score
    end
  end

private

  def reset_event_attribute(attribute, eps)
    if score_params[attribute.to_sym] == '1'
      @pp = eps.event_player
      @pc = eps.participating_country
      @pp.set_attribute_to_true(attribute, @pc)
    end
  end

  def load_eps
    @eps = EventPlayerScore.
           joins(:event, :participating_country).
           find_by(
             'events.year = ? AND participating_countries.position = ?',
             params[:year],
             params[:act]
           )
  end

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

  def score_params
    params.require(:event_player_score).permit(:notes, :score, :best_wail, :wackiest, :fattest)
  end
end
