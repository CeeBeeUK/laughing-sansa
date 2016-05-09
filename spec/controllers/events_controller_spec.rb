require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  include Devise::TestHelpers

  let(:valid_attributes) do
    {
      year: 2016,
      country_id: 1,
      host_city: 'london'
    }
  end

  let(:invalid_attributes) do
    {
      year: nil,
      country_id: nil,
      host_city: nil
    }
  end

  let(:valid_session) { {} }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  context 'logged out user' do
    describe 'GET #index' do
      it 'redirects to login page' do
        get :index, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #show' do
      it 'redirects to login page' do
        event = create(:event)
        get :show, { year: event.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #new' do
      it 'redirects to login page' do
        get :new, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #edit' do
      it 'redirects to login page' do
        event = create(:event)
        get :edit, { year: event.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #admin' do
      it 'redirects to login page' do
        event = create(:event)
        get :edit, { year: event.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'logged in as user' do
    before(:each) do
      sign_in user
    end
    describe 'GET #index' do
      it 'assigns all events as @events' do
        event = create(:event)
        get :index, {}, valid_session
        expect(assigns(:events)).to include(event)
      end
    end
    describe 'GET #show' do
      it 'assigns the requested event as @event' do
        event = create(:event)
        event_player = create(:event_player, player: user, event: event)
        get :show, { year: event_player.event.to_param }, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'GET #admin' do
      it 'redirects to login page' do
        event = create(:event)
        get :edit, { year: event.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #new' do
      it 'redirects to login page' do
        get :new, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #edit' do
      it 'redirects to login page' do
        event = create(:event)
        get :edit, { year: event.to_param }, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #join' do
      let(:event_player) { create(:event_player) }
      before :each do
        get :join, year: event_player.event.to_param
      end
      it 'assigns the requested pp to @event_player' do
        expect(assigns(:event_player)).to be_a_new(EventPlayer)
      end
      it 'renders the view' do
        expect(response).to render_template :join
      end
    end
  end

  context 'logged in as admin' do
    let(:event) { create(:event) }
    before(:each) do
      sign_in admin_user
    end
    describe 'GET #index' do
      it 'assigns all events as @events' do
        get :index, {}, valid_session
        expect(assigns(:events)).to include(event)
      end
    end
    describe 'GET #show' do
      it 'assigns the requested event as @event' do
        event_player = create(:event_player, player: user, event: event)
        get :show, { year: event_player.event.to_param }, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'GET #new' do
      it 'assigns a new event to @event' do
        get :new, params: {}, session: valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end
    end
    describe 'GET #edit' do
      it 'assigns the requested event as @event' do
        get :edit, { year: event.to_param }, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'GET #admin' do
      it 'assigns the requested event as @event' do
        get :admin, { year: event.to_param }, valid_session
        expect(assigns(:event)).to be_a Event
        expect(assigns(:data)).to be_a AdminData
      end
    end
    describe 'GET #join' do
      let(:event_player) { create(:event_player) }
      before :each do
        get :join, year: event_player.event.to_param
      end
      it 'assigns the requested pp to @event_player' do
        expect(assigns(:event_player)).to be_a_new(EventPlayer)
      end
      it 'renders the view' do
        expect(response).to render_template :join
      end
    end
    describe 'GET #join' do
      context 'when player has already joined' do
        let(:event_player) do
          create(:event_player,
            event: create(:event, status: 1),
            player: admin_user)
        end
        before(:each) do
          get :join, year: event_player.event.to_param
        end
        it 'returns a redirect code' do
          expect(response.status).to eql(302)
        end
        it 'renders the players game template' do
          expect(response).to redirect_to my_game_path(event_player.event)
        end
      end
    end
    describe 'POST #sign_up' do
      context 'with valid params' do
        let(:event_player) { build(:event_player) }
        it 'creates a new participating player' do
          expect do
            post :sign_up, year: event_player.event.year, event_player: event_player.attributes
          end.to change(EventPlayer, :count).by(1)
        end
        it 'redirects to the event view' do
          post :sign_up, year: event_player.event.year, event_player: event_player.attributes
          expect(response).to redirect_to(event_player.event)
        end
      end
      context 'with invalid params' do
        let(:bad_pp) { build(:invalid_pp) }

        it 're-renders to the join view' do
          post :sign_up, year: bad_pp.event.year, event_player: bad_pp.attributes
          expect(response).to render_template :join
        end
      end
    end
    describe 'POST #create' do
      context 'with valid params' do
        let(:event) { build(:event) }

        it 'creates a new Event' do
          expect do
            post :create, { event: event.attributes }, valid_session
          end.to change(Event, :count).by(1)
        end

        it 'assigns a newly created event as @event' do
          post :create, { event: event.attributes }, valid_session
          expect(assigns(:event)).to be_a(Event)
          expect(assigns(:event)).to be_persisted
        end

        it 'redirects to the created event' do
          post :create, { event: event.attributes }, valid_session
          expect(response).to redirect_to(Event.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved event as @event' do
          post :create, { event: invalid_attributes }, valid_session
          expect(assigns(:event)).to be_a_new(Event)
        end

        it 're-renders the "new" template' do
          post :create, { event: invalid_attributes }, valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      let(:event) { create(:event) }
      context 'with valid params' do
        let(:new_attributes) { event.attributes }
        before(:each) { new_attributes['host_city'] += 'test' }
        it 'updates the requested event' do
          expect = "#{event.host_city}test"
          put :update, { year: event.to_param, event: new_attributes }, valid_session
          event.reload
          expect(event.host_city).to eql(expect)
        end

        it 'assigns the requested event as @event' do
          put :update, { year: event.to_param, event: new_attributes }, valid_session
          expect(assigns(:event)).to eq(event)
        end

        it 'redirects to the event' do
          put :update, { year: event.to_param, event: new_attributes }, valid_session
          expect(response).to redirect_to(event)
        end
      end

      context 'with invalid params' do
        it 'assigns the event as @event' do
          put :update, { year: event.to_param, event: invalid_attributes }, valid_session
          expect(assigns(:event)).to eq(event)
        end

        it 're-renders the "edit" template' do
          put :update, { year: event.to_param, event: invalid_attributes }, valid_session
          expect(response).to render_template('edit')
        end
      end
    end
  end
end
