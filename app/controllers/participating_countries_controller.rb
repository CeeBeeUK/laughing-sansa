class ParticipatingCountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_variables, only: [:manage]
  respond_to :html

  def manage
  end

private

  def load_variables
    @event = Event.find_by(year: params[:year])
    @countries = Country.sorted_by_name
    @users = User.all
  end

end
