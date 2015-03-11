require 'rails_helper'

RSpec.describe "Countries", :type => :request do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  describe "GET /countries" do
    it "Redirects us when not authenticated." do
      get countries_path
      expect(response.status).to eql(302)
    end

    it "Redirects us when not authorised." do
      login_as(user, :scope => :user)
      get countries_path
      expect(response.status).to eql(302)
    end

    it "Gives is the expected status code when authenticated." do
      login_as(admin_user, :scope => :user)
      get countries_path
      expect(response.status).to eql(200)
    end
  end
end
