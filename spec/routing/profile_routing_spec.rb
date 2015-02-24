require "rails_helper"

RSpec.describe ProfileController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/my_profile").to route_to("profile#show")
    end
  end
end
