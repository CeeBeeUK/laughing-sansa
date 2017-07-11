class CountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_country, only: %i[show edit update destroy]
  respond_to :html

  def index
    @countries = Country.sorted_by_name
    respond_with(@countries)
  end

  def show
    respond_with(@country)
  end

  def new
    @country = Country.new
    respond_with(@country)
  end

  def edit; end

  def create
    @country = Country.new(country_params)
    @country.save
    respond_with(@country)
  end

  def update
    @country.update(country_params)
    respond_with(@country)
  end

  def destroy
    @country.destroy
    respond_with(@country)
  end

  private

  def set_country
    @country = Country.find_by(name: params[:name])
  end

  def country_params
    params.require(:country).permit(:name, :image_path)
  end
end
