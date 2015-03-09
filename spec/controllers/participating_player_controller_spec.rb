require 'rails_helper'

RSpec.describe ParticipatingPlayerController, type: :controller do

  include Devise::TestHelpers

  let(:valid_attributes) {{
      predicted_uk_score: 100
  }}

  let(:invalid_attributes) {{
      predicted_uk_score: nil
  }}

  let(:valid_session) { {} }

  let(:user) { FactoryGirl.create :user }

  context 'logged in as user' do
    before(:each) do
      sign_in user
    end
    describe 'GET #new' do
      it 'should assign a new event to @event' do
        pp = FactoryGirl.build :participating_player
        pp.event.active!
        get new_join_game(pp), {}, valid_session
        expect(assigns(pp)).to be_a_new(ParticipatingPlayer)
      end
    end
  end
end
