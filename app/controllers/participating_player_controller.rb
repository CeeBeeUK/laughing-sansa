class ParticipatingPlayerController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_event, only: [:join, :create]
  respond_to :html

  def join
    @participating_player = ParticipatingPlayer.new
    @participating_player.event = @event
    @participating_player.player = current_user
    respond_with(@participating_player)
  end

  def create
    @participating_player = ParticipatingPlayer.new(
      participating_player_params.merge(
        player_id: current_user.id,
        event_id: @event.id
      )
    )
    if @participating_player.valid?
      @participating_player.save
      respond_with(@participating_player)
    else
      render action: :join
    end
  end

private

  def set_event
    @event = Event.find_by(year: params[:year])
  end

  def participating_player_params
    params.require(:participating_player).permit(:predicted_uk_score)
  end
end
