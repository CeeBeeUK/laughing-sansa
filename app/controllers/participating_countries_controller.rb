class ParticipatingCountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_variables, only: %i[manage sort create]
  before_action :find_pc, only: [:allocate]
  respond_to :html

  def manage; end

  def sort
    params[:pc].each_with_index do |id, index|
      ParticipatingCountry.where(event: @event, id:).update(position: index + 1)
    end
    head :ok
  end

  def create
    begin
      params = participating_country_params[:country_id]
      @participating_country = ParticipatingCountry.new(event: @event, country_id: params)
      @participating_country.insert_at(1)
      @participating_country.save!
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
      flash[:alert] = 'Country already in event'
    end
    redirect_to manage_countries_path(@event)
  end

  def allocate
    @pc.update(
      player_id: allocate_params[:player_id],
      real_final_score: allocate_params[:real_final_score]
    )
    flash[:alert] = @pc.errors.full_messages unless @pc.save
    redirect_to manage_countries_path(@pc.event)
  end

  private

  def find_pc
    @pc = ParticipatingCountry.find(params[:participating_country][:id])
  end

  def load_variables
    @event = Event.find_by(year: params[:year])
    @countries = Country.sorted_by_name
    @users = User.all
    @participating_country = ParticipatingCountry.new
  end

  def participating_country_params
    params.require(:participating_country).permit(:country_id)
  end

  def allocate_params
    params.require(:participating_country).permit(:player_id, :real_final_score)
  end
end
