require 'rails_helper'

RSpec.describe 'events/index', type: :view do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }

  before(:each) do
    country = FactoryGirl.create :country
    assign(:events, [
      Event.create!(
        :year => 2010,
        :host_city => 'Host City',
        :active => false,
        :country => country
      ),
      Event.create!(
        :year => 2011,
        :host_city => 'Host City',
        :active => false,
        country: country
      )
    ])
  end

  it 'renders a list of events' do
    sign_in user
    render
    assert_select 'li span.year', :text => 2010.to_s, :count => 1
    assert_select 'li span.year', :text => 2011.to_s, :count => 1
    assert_select 'li span.host-city', :text => 'Host City'.to_s, :count => 2
  end
end
