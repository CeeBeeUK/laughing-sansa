require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  include Devise::TestHelpers

  let(:valid_attributes) {{
      year: 2016,
      country_id: 1,
      host_city: 'london'
  }}

  let(:invalid_attributes) {{
      year: nil,
      country_id: nil,
      host_city: nil
  }}

  let(:valid_session) { {} }

  let(:user) { FactoryGirl.create :user }
  let(:admin_user) { FactoryGirl.create :admin_user }

  context 'logged out user' do
    describe 'GET #index' do
      it 'redirects to login page' do
        get :index, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #show' do
      it 'redirects to login page' do
        event = FactoryGirl.create :event
        get :show, {:id => event.to_param}, valid_session
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
      it 'should redirect to login page' do
        event = FactoryGirl.create :event
        get :edit, {:id => event.to_param}, valid_session
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
        event = FactoryGirl.create :event
        get :index, {}, valid_session
        expect(assigns(:events)).to include(event)
      end
    end
    describe 'GET #show' do
      it 'assigns the requested event as @event' do
        event = FactoryGirl.create :event
        get :show, {:id => event.to_param}, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'GET #new' do
      it 'should redirect to login page' do
        get :new, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
    describe 'GET #edit' do
      it 'should redirect to login page' do
        event = FactoryGirl.create :event
        get :edit, {:id => event.to_param}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'logged in as admin' do
    before(:each) do
      sign_in admin_user
    end
    describe 'GET #index' do
      it 'should assigns all events as @events' do
        event = FactoryGirl.create :event
        get :index, {}, valid_session
        expect(assigns(:events)).to include(event)
      end
    end
    describe 'GET #show' do
      it 'should assigns the requested event as @event' do
        event = FactoryGirl.create :event
        get :show, {:id => event.to_param}, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'GET #new' do
      it 'should assign a new event to @event' do
        get :new, {}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end
    end
    describe 'GET #edit' do
      it 'should assign the requested event as @event' do
        event = FactoryGirl.create :event
        get :edit, {:id => event.to_param}, valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
    describe 'POST #create' do
      context 'with valid params' do
        let(:event) { FactoryGirl.build :event }

        it 'should create a new Event' do
          expect {
            post :create, {:event => event.attributes}, valid_session
          }.to change(Event, :count).by(1)
        end

        it 'should assign a newly created event as @event' do
          post :create, {:event => event.attributes}, valid_session
          expect(assigns(:event)).to be_a(Event)
          expect(assigns(:event)).to be_persisted
        end

        it 'redirects to the created event' do
          post :create, {:event => event.attributes}, valid_session
          expect(response).to redirect_to(Event.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved event as @event' do
          post :create, {:event => invalid_attributes}, valid_session
          expect(assigns(:event)).to be_a_new(Event)
        end

        it 're-renders the "new" template' do
          post :create, {:event => invalid_attributes}, valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      let(:event) { FactoryGirl.create :event }
      context 'with valid params' do
        let(:new_attributes) { event.attributes  }
        before(:each) { new_attributes['host_city'] += 'test' }
        it 'updates the requested event' do
          expect = "#{event.host_city}test"
          put :update, {:id => event.to_param, :event => new_attributes}, valid_session
          event.reload
          expect(event.host_city).to eql(expect)
        end

        it 'assigns the requested event as @event' do
          put :update, {:id => event.to_param, :event => new_attributes}, valid_session
          expect(assigns(:event)).to eq(event)
        end

        it 'redirects to the event' do
          put :update, {:id => event.to_param, :event => new_attributes}, valid_session
          expect(response).to redirect_to(event)
        end
      end

      context 'with invalid params' do
        it 'assigns the event as @event' do
          put :update, {:id => event.to_param, :event => invalid_attributes}, valid_session
          expect(assigns(:event)).to eq(event)
        end

        it 're-renders the "edit" template' do
          put :update, {:id => event.to_param, :event => invalid_attributes}, valid_session
          expect(response).to render_template('edit')
        end
      end
    end
  end
end
