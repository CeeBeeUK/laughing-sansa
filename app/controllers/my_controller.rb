class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: %i[profile profile_update game]
  before_action :load_pp, only: [:game]
  before_action :load_eps, only: %i[game score score_create]
  respond_to :html

  def profile
    authorize! :read, User
  end

  def profile_update
    authorize! :update, User
    @user.update_attributes(display_name: user_params[:display_name])
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
    return unless true? score_params[attribute.to_sym]
    @pp = eps.event_player
    @pc = eps.participating_country
    @pp.set_attribute_to_true(attribute, @pc)
  end

  def true?(value)
    if [true, '1'].include?(value)
      true
    else
      false
    end
  end

  def load_eps
    load_pp
    return unless @pp
    @eps = EventPlayerScore
           .joins(:event, :participating_country)
           .find_by(
             'events.year = ? AND participating_countries.position = ? AND event_player_id = ?',
             params[:year], params[:act], @pp.id
           )
  end

  def load_user
    @user = User.find_by(email: current_user.email)
  end

  def load_pp
    @user = User.find_by(email: current_user.email)
    @event = Event.find_by(year: params[:year])
    @pp = EventPlayer.find_by(player_id: @user.id, event_id: @event.id)
  end

  def user_params
    params.require(:user).permit(:display_name)
  end

  def score_params
    params.require(:event_player_score).permit(:notes, :score, :best_wail, :wackiest, :fattest)
  end
end
