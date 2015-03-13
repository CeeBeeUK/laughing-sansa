class EventsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_event, only: [:show, :edit, :update, :join, :sign_up]
  before_action :load_variables, only: [:new, :edit, :create, :update]
  respond_to :html

  def index
    @events = Event.last_to_first
    respond_with(@events)
  end

  def show
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def join
    authorize! :join, Event
    @participating_player = ParticipatingPlayer.new
    @participating_player.event = @event
    @participating_player.player = current_user
    respond_with(@participating_player)
  end

  def sign_up
    authorize! :sign_up, Event
    @participating_player = build_sign_up_pp
    if @participating_player.valid?
      @participating_player.save
      redirect_to event_path(@participating_player.event)
    else
      render action: :join
    end
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

private

  def build_sign_up_pp
    ParticipatingPlayer.new(
      participating_player_params.merge(
        player_id: current_user.id,
        event_id: @event.id
      )
    )
  end

  def set_event
    @event = Event.find_by(year: params[:year])
  end

  def load_variables
    @countries = Country.sorted_by_name
    @users = User.all
  end

  def participating_player_params
    params.require(:participating_player).permit(:predicted_uk_score)
  end

  def event_params
    params.require(:event).permit(:year, :host_city, :active, :country_id, :real_winner_id,
      :real_player_id, :real_score, :real_player_name, :home_winner_id, :home_player_id,
      :home_score, :home_player_name, :status, :date)
  end
end
