class ParticipatingCountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_variables, only: [:manage, :sort, :create]
  respond_to :html

  def manage
  end

  def sort
    params[:pc].each_with_index do |id, index|
      ParticipatingCountry.where(event: @event, id: id).update_all(position: index + 1)
    end
    render nothing: true
  end

  def create
    begin
      @participating_country = ParticipatingCountry.new(
        event: @event, country_id: participating_country_params[:country_id]
      )
      @participating_country.insert_at(1)
      @participating_country.save
    rescue ActiveRecord::RecordNotUnique
      flash[:alert] = 'Country already in event'
    rescue => e
      flash[:alert] = e
    end
    redirect_to manage_countries_path(@event)
  end

private

  def load_variables
    @event = Event.find_by(year: params[:year])
    @countries = Country.sorted_by_name
    @users = User.all
    @participating_country = ParticipatingCountry.new
  end

  def participating_country_params
    params.require(:participating_country).permit(:country_id)
  end
end
