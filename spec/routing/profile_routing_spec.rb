require "rails_helper"

RSpec.describe ProfileController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/my_profile").to route_to("profile#index")
    end
  end
end
