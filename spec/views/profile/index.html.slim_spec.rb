require 'rails_helper'

RSpec.describe "profile/index.html.slim", type: :view do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }

  it 'should have a Main Page header' do
    sign_in user
    render
    expect(rendered).to include(user.email)
  end
end
