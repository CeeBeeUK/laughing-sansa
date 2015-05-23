class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:profile, :profile_update, :game]
  before_action :load_pp, only: [:game]
  before_action :load_eps, only: [:game, :score, :score_create]
  respond_to :html

  def profile
    authorize! :read, User
  end

  def profile_update
    authorize! :update, User
    @user.update_column(:display_name, user_params[:display_name])
    redirect_to my_profile_path
  end

  def game
    authorize! :read, Event
    return respond_with(@pp) if @pp
    if @event.active?
      redirect_to game_sign_up_path(@event)
    else
      flash[:alert] = 'This game cannot be joined'
      redirect_to root_path
    end
  end

  def score
    authorize! :read, EventPlayerScore
  end

  def score_create
    authorize! :update, EventPlayerScore
    if @eps.update(score_params)
      reset_event_attribute('fattest', @eps)
      reset_event_attribute('wackiest', @eps)
      reset_event_attribute('best_wail', @eps)
    end
    redirect_to my_game_path(@eps.event)
  end

private

  def reset_event_attribute(attribute, eps)
    if true? score_params[attribute.to_sym]
      @pp = eps.event_player
      @pc = eps.participating_country
      @pp.set_attribute_to_true(attribute, @pc)
    end
  end

  def true?(value)
    if value == true || value == '1'
      true
    else
      false
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
    Rails.logger.info "Setting finding EventPlayer using player_id:#{current_user.id} and event_id=#{@event_id}"
    @pp = EventPlayer.find_by(player_id: current_user.id, event_id: @event.id)
  end

  def user_params
    params.require(:user).permit(:display_name)
  end

  def score_params
    params.require(:event_player_score).permit(:notes, :score, :best_wail, :wackiest, :fattest)
  end
end
