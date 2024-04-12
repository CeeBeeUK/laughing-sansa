class KidsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_players, only: %i[game score_act]
  respond_to :html

  def game
    authorize! :manage, Event
    event_players = EventPlayer.where(event: @event, player_id: @players.pluck(:id))
    @event_player_scores = EventPlayerScore.where(event_player: event_players)
  end

  def score_act
    authorize! :manage, Event
    participating_country = ParticipatingCountry.find_by(event: @event, position: scoring_params[:act])
    event_players = EventPlayer.where(event: @event, player_id: @players.pluck(:id))
    @event_player_scores = EventPlayerScore.where(participating_country:, event_player: event_players)
    @participating_country = participating_country
  end

  def create_score
    authorize! :manage, Event
    eps = EventPlayerScore.find(params[:eps])
    score = params[:event_player_score][:score]
    redirect_to kids_scoring_event_path(eps.event) if eps.update!(score:)
  end

  def join_game
    authorize! :manage, Event
    event = Event.find_by(year: sign_up_params[:year])
    player = User.find(sign_up_params[:player])
    EventPlayer.create(player:, event:, predicted_uk_score: 0)
    redirect_to kids_scoring_event_path(event)
  end

  private

  def load_players
    @event = Event.find_by(year: params[:year])
    @players = User.where(encrypted_password: '').order(:id)
  end

  def sign_up_params
    params.permit(:year, :player)
  end

  def scoring_params
    params.permit(:year, :act)
  end
end
