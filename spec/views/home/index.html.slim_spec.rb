require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do

  include Devise::TestHelpers

  let(:user) { create(:user) }

  it 'has a Main Page header' do
    render
    expect(rendered).to include('Bruce-Burton Eurovision scoring')
  end
  context 'logged out user' do
    it 'will see a log in prompt' do
      render
      expect(rendered).to include('To sign in, click the')
    end
  end
  context 'logged in user' do
    it 'will see guidance' do
      sign_in user
      render
      expect(rendered).to include('Welcome to the 2015+ scoring system')
    end
  end
end
