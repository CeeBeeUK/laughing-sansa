class UsersController < ApplicationController
  respond_to :html
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.all.order(:id)
  end
end
