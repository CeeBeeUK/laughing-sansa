require 'rails_helper'

RSpec.describe 'events/show', type: :view do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }

  before(:each) do
    @event = FactoryGirl.create :event
    @event.country = FactoryGirl.create :country
  end

  it 'renders attributes' do
    sign_in user
    render
    expect(rendered).to match(/#{@event.year}/)
    expect(rendered).to match(/london/)

  end
end
