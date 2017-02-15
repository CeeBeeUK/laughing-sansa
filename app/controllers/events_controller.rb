class EventsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_event, only: [:show, :edit, :update, :join, :sign_up, :admin]
  before_action :load_variables, only: [:new, :edit, :create, :update]
  respond_to :html

  def index
    @events = Event.last_to_first
    respond_with(@events)
  end

  def show
    pp = EventPlayer.find_by(player_id: current_user.id, event_id: @event.id)
    @current_user_prediction = pp.nil? ? nil : pp.predicted_uk_score
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    if @event.country.present?
      @event.add_big_five
    else
      @event.save
    end
    respond_with(@event)
  end

  def join
    authorize! :join, Event
    event_player = EventPlayer.find_by(event: @event.id, player: current_user)
    if event_player
      flash[:notice] = 'You have previously joined this game'
      return redirect_to my_game_path(@event)
    end
    @event_player = EventPlayer.new
    @event_player.event = @event
    @event_player.player = current_user
    respond_with(@event_player)
  end

  def sign_up
    authorize! :sign_up, Event
    @event_player = build_sign_up_pp
    if @event_player.valid?
      @event_player.save
      redirect_to event_path(@event_player.event)
    else
      render action: :join
    end
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def admin
    @data = AdminData.new(params[:year])
  end

private

  def build_sign_up_pp
    EventPlayer.new(
      event_player_params.merge(
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

  def event_player_params
    params.require(:event_player).permit(:predicted_uk_score)
  end

  def event_params
    params.require(:event).permit(:year, :host_city, :active, :country_id, :real_winner_id,
      :real_player_id, :real_score, :real_player_name, :home_winner_id, :home_player_id,
      :home_score, :home_player_name, :status, :date, :actual_uk_score)
  end
end
