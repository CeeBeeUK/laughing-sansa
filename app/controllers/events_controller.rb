class EventsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_event, only: [:show, :edit, :update]
  before_action :get_countries, only: [:new, :edit, :create, :update]
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

  def update
    @event.update(event_params)
    respond_with(@event)
  end

private
  def set_event
    @event = Event.find_by(year: params[:year])
  end

  def get_countries
    @countries = Country.sorted_by_name
    @users = User.all
  end

  def event_params
    params.require(:event)
      .permit(
        :year,
        :host_city,
        :active,
        :country_id,
        :real_winner_id,
        :real_player_id,
        :real_score,
        :real_player_name,
        :home_winner_id,
        :home_player_id,
        :home_score,
        :home_player_name,
        :status,
        :date
      )
  end
end
