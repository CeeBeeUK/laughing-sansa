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
  end
end
