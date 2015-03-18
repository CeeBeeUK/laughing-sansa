class MyController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:profile]
  respond_to :html

  def profile
  end

  def profile_update
    @user.update_column(:display_name, user_params[:display_name])
    redirect_to my_profile_path
  end

private

  def load_user
    @user = User.find_by(email: current_user.email)
  end

  def user_params
    params.require(:user).permit(:display_name)
  end
end
