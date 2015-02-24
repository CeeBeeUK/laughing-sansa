require 'rails_helper'

RSpec.describe ProfileController, type: :controller do

  include Devise::TestHelpers
  let(:user) { FactoryGirl.create :user }

  describe "GET #show" do
    it "returns http success" do
      sign_in user
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
