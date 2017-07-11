require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)          { build(:user) }
  let(:admin_user)    { build(:admin_user) }

  it 'passes factory build' do
    expect(user).to be_valid
  end

  describe 'validation' do
    it 'requires an email' do
      user.email = nil
      expect(user).to be_invalid
    end

    it 'requires a valid email' do
      user.email = 'testemail'
      expect(user).to be_invalid
    end

    it 'requires a unique email' do
      described_class.create(email: 'test@duplicate.com', role: 'user')
      duplicate = described_class.new(role: 'admin', email: 'test@duplicate.com')
      expect(duplicate).to be_invalid
    end

    describe 'requires a non-nil role' do
      subject(:user_valid) { user.valid? }

      before do
        user.role = nil
        user.valid?
      end

      it { expect(user_valid).to be false }
      it { expect(user.errors[:role]).to eq ["can't be blank"] }
    end

    describe 'requires a valid role' do
      before do
        user.role = 'student'
        expect(user).to be_invalid
      end

      it { expect(user.errors[:role]).to eq ['student is not a valid role'] }
    end

    it 'returns the oaauth first name if display name empty' do
      user.display_name = nil
      expect(user.display_name).to eql('test')
    end

    it 'returns the display name if explicitly set' do
      user.display_name = 'wibble'
      expect(user.display_name).to eql('wibble')
    end
  end
  describe '@in_event?' do
    let(:user) { create :user }
    let(:event) { create :event }

    before { create(:event_player, event: event, player: user) }
    it 'responds true if a player has joined an event' do
      expect(user.in_event?(event)).to be true
    end
  end
  describe '@display_name_set?' do
    it 'responds true if a name is explicitly set' do
      user.display_name = 'CeeBee'
      expect(user.display_name_set?).to be true
    end

    describe 'returns false' do
      subject { user.display_name_set? }

      before { user.display_name = display_name }

      describe 'when it is nil' do
        let(:display_name) { nil }

        it { is_expected.to be false }
      end

      describe 'when it is an empty string' do
        let(:display_name) { '' }

        it { is_expected.to be false }
      end
    end
  end
  describe '@admin?' do
    it 'responds true if admin user' do
      expect(admin_user.admin?).to be true
    end

    it 'responds false if not admin user' do
      expect(user.admin?).to be false
    end
  end
  context 'an existing user' do
    before do
      described_class.create(email: 'test_create@example.com', name: 'Test User', role: 'user')
      expect do
        described_class.find_for_google_oauth2(user_struct)
      end.not_to change(described_class, :count)
    end
    let(:user_struct) { OpenStruct.new(info: { 'email' => 'test_create@example.com', 'name' => 'Test User' }) }

    let(:user2) { described_class.find_for_google_oauth2(user_struct) }

    it 'can be found' do
      expect(user2).to be_valid
    end
  end
  context 'when credentials valid' do
    let(:user_struct) do
      OpenStruct.new(info: { 'email' => 'test_create_unique@example.com', 'name' => 'Test User' })
    end

    it 'will create a new user' do
      expect do
        described_class.find_for_google_oauth2(user_struct)
      end.to change(described_class, :count).by(1)
    end
  end
end
