require 'rails_helper'

RSpec.describe CountriesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:valid_attributes) { { name: "United Kingdom #{SecureRandom.hex(4)}" } }

  let(:invalid_attributes) { { name: nil } }

  let(:valid_session) { {} }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  context 'as a logged in admin' do

    before { sign_in admin_user }

    describe 'GET index' do
      it 'assigns all countries as @countries' do
        country = Country.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(assigns(:countries)).to include(country)
      end
    end

    describe 'GET show' do
      it 'assigns the requested country as @country' do
        country = Country.create! valid_attributes
        get :show, params: { name: country.to_param }, session: valid_session
        expect(assigns(:country)).to eq(country)
      end
    end

    describe 'GET new' do
      it 'assigns a new country as @country' do
        get :new, params: {}, session: valid_session
        expect(assigns(:country)).to be_a_new(Country)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested country as @country' do
        country = Country.create! valid_attributes
        get :edit, params: { name: country.to_param }, session: valid_session
        expect(assigns(:country)).to eq(country)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new Country' do
          expect do
            post :create, params: { country: valid_attributes }, session: valid_session
          end.to change(Country, :count).by(1)
        end

        describe 'assigns a newly created country as @country' do
          before { post :create, params: { country: valid_attributes }, session: valid_session }
          it { expect(assigns(:country)).to be_a(Country) }
          it { expect(assigns(:country)).to be_persisted }
        end

        it 'redirects to the created country' do
          post :create, params: { country: valid_attributes }, session: valid_session
          expect(response).to redirect_to(Country.last)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved country as @country' do
          post :create, params: { country: invalid_attributes }, session: valid_session
          expect(assigns(:country)).to be_a_new(Country)
        end

        it 're-renders the "new" template' do
          post :create, params: { country: invalid_attributes }, session: valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        let(:new_attributes) { { name: 'uk' } }

        it 'updates the requested country' do
          country = Country.create! valid_attributes
          put :update, params: { name: country.to_param, country: new_attributes }, session: valid_session
          country.reload
          expect(country.name).to eql('uk')
        end

        it 'assigns the requested country as @country' do
          country = Country.create! valid_attributes
          put :update, params: { name: country.to_param, country: valid_attributes }, session: valid_session
          expect(assigns(:country)).to eq(country)
        end

        it 'redirects to the country' do
          country = Country.create! valid_attributes
          put :update, params: { name: country.to_param, country: valid_attributes }, session: valid_session
          expect(response).to redirect_to(country)
        end
      end

      describe 'with invalid params' do
        it 'assigns the country as @country' do
          country = Country.create! valid_attributes
          put :update, params: { name: country.to_param, country: invalid_attributes }, session: valid_session
          expect(assigns(:country)).to eq(country)
        end

        it 're-renders the "edit" template' do
          country = Country.create! valid_attributes
          put :update, params: { name: country.to_param, country: invalid_attributes }, session: valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested country' do
        country = Country.create! valid_attributes
        expect do
          delete :destroy, params: { name: country.to_param }, session: valid_session
        end.to change(Country, :count).by(-1)
      end

      it 'redirects to the countries list' do
        country = Country.create! valid_attributes
        delete :destroy, params: { name: country.to_param }, session: valid_session
        expect(response).to redirect_to(countries_url)
      end
    end
  end
end
