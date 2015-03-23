require 'rails_helper'

RSpec.describe ParticipatingCountriesController, type: :controller do

  include Devise::TestHelpers
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let(:valid_session) { {} }

  # sort
  # create

  context 'as a guest' do
    let(:event) { create(:event) }
    describe 'GET #manage' do
      before(:each) { get :manage, year: event.year }
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'redirect to event page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'as a user' do
    let(:event) { create(:event) }
    before(:each) do
      sign_in user
    end
    describe 'GET #manage' do
      before(:each) { get :manage, year: event.year }
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'redirect to event page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'logged in as admin' do
    describe 'GET #manage' do
      let(:event) { create(:event) }
      before(:each) do
        sign_in admin
        get :manage, year: event.year
      end
      it 'returns a 200 status code' do
        expect(response.status).to eql(200)
      end
      it 'renders the template' do
        expect(response).to render_template :manage
      end
    end
    describe 'POST #sort' do
      let(:event) { create(:event) }
      let(:pc_1) {
        create(:participating_country,
          event: event,
          country: create(:country),
          position: 1)
      }
      let(:pc_2) {
        create(:participating_country,
          event: event,
          country: create(:country),
          position: 2)
      }
      before(:each) do
        sign_in admin
        post :sort, pc: [pc_2.position, pc_1.position], year: event.year
      end
      it 'returns a 200 status code' do
        expect(response.status).to eql(200)
      end
      it 'renders nothing' do
        expect(response).to render_template(nil)
      end
    end
  end
end
