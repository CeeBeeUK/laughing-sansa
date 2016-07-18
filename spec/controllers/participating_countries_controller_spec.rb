require 'rails_helper'

RSpec.describe ParticipatingCountriesController, type: :controller do

  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let(:valid_session) { {} }

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
    describe 'POST #sort' do
      before(:each) do
        post :sort, pc: [2, 1], year: event.year
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'POST #create' do
      before(:each) do
        post :create, participating_country_id: create(:country).id, year: event.year
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'POST #allocate' do
      before(:each) do
        post :allocate, participating_country_id: create(:country).id, year: event.year, player_id: create(:user).id
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
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
    describe 'POST #sort' do
      before(:each) do
        post :sort, pc: [2, 1], year: event.year
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'POST #create' do
      let(:participating_country) { create(:participating_country) }
      before(:each) do
        post :create, participating_country: { country_id: participating_country.country.id }, year: event.year
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'POST #allocate' do
      before(:each) do
        post :allocate, participating_country_id: create(:country).id, year: event.year, player_id: create(:user).id
      end
      it 'returns a 302 status code' do
        expect(response.status).to eql(302)
      end
      it 'renders nothing' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'logged in as admin' do
    let(:event) { create(:event) }
    describe 'GET #manage' do
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
      let(:pc_1) do
        create(:participating_country,
          event: event,
          country: create(:country),
          position: 1)
      end
      let(:pc_2) do
        create(:participating_country,
          event: event,
          country: create(:country),
          position: 2)
      end
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
    describe 'POST #create' do
      context 'with valid params' do
        let(:participating_country) { create(:participating_country) }
        before(:each) do
          sign_in admin
          post :create, participating_country: { country_id: participating_country.country.id }, year: event.year
        end
        it 'returns a 302 status code' do
          expect(response.status).to eql(302)
        end
        it 'renders the management view' do
          expect(response).to redirect_to manage_countries_path(event)
        end
      end
      context 'when attempting to create a duplicate participating country' do
        let(:participating_country) { create(:participating_country) }
        before(:each) do
          sign_in admin
          post :create, participating_country: { country_id: participating_country.country.id }, year: event.year
          post :create, participating_country: { country_id: participating_country.country.id }, year: event.year
        end
        it 'displays a flash alert' do
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eql('Country already in event')
        end
      end
    end
    describe 'POST allocate' do
      context 'with valid params' do
        let(:participating_country) { create(:participating_country) }
        let(:player) { create(:user) }
        before(:each) do
          sign_in admin
          post :allocate, year: event.year, participating_country: { id: participating_country.id, player_id: player.id }
        end
        it 'returns a 302 code' do
          expect(response.status).to eql(302)
        end
        it 'renders the management view' do
          expect(response).to redirect_to manage_countries_path(participating_country.event)
        end
        it 'does not set a flash message' do
          expect(flash[:alert]).not_to be_present
        end
        it 'sets the player on the PC' do
          participating_country.reload
          expect(participating_country.player_id).to eql(player.id)
        end
      end
      context 'with invalid params' do
        let(:participating_country) { create(:participating_country) }
        let(:player) { create(:user) }
        before(:each) do
          sign_in admin
          post :allocate, year: event.year, participating_country: { id: participating_country.id, player_id: 'bob' }
        end
        it 'returns a 302 code' do
          expect(response.status).to eql(302)
        end
        it 'renders the management view' do
          expect(response).to redirect_to manage_countries_path(participating_country.event)
        end
        it 'sets a flash message' do
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eql(['Player is not a number'])
        end
        it 'does not amend the player on the PC' do
          participating_country.reload
          expect(participating_country.player_id).not_to eql(player.id)
        end
      end
    end
  end
end
