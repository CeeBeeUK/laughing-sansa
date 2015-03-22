class ParticipatingCountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_variables, only: [:manage, :sort]
  respond_to :html

  def manage
  end

  def sort
    params[:pc].each_with_index do |id, index|
      ParticipatingCountry.where(event: @event, id: id).update_all(position: index + 1)
    end
    render nothing: true
  end

private

  def load_variables
    @event = Event.find_by(year: params[:year])
    @countries = Country.sorted_by_name
    @users = User.all
  end

end
