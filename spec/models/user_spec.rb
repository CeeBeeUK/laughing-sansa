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
      described_class.create(
        email: 'test@duplicate.com',
        role: 'user'
      )
      duplicate = described_class.new(
        role: 'admin',
        email: 'test@duplicate.com'
      )
      expect(duplicate).to be_invalid
    end

    it 'requires a non-nil role' do
      user.role = nil
      expect(user).to be_invalid
      expect(user.errors[:role]).to eq ["can't be blank"]
    end

    it 'requires a valid role' do
      user.role = 'student'
      expect(user).to be_invalid
      expect(user.errors[:role]).to eq ['student is not a valid role']
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
    it 'responds true if a player has joined an event' do
      user = create(:user)
      event = create(:event)
      expect(user.in_event?(event)).to be false
      create(:event_player, event: event, player: user)
      expect(user.in_event?(event)).to be true
    end
  end
  describe '@display_name_set?' do
    it 'responds true if a name is explicitly set' do
      user.display_name = 'CeeBee'
      expect(user.display_name_set?).to be true
    end

    it 'responds false if not admin user' do
      user.display_name = nil
      expect(user.display_name_set?).to be false
      user.display_name = ''
      expect(user.display_name_set?).to be false
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
  it 'can find existing user' do
    described_class.create(
      email: 'test_create@example.com',
      name: 'Test User',
      role: 'user'
    )
    user_struct = OpenStruct.new(
      info: {
        'email' => 'test_create@example.com',
        'name' => 'Test User'
      }
    )
    expect do
      described_class.find_for_google_oauth2(user_struct)
    end.not_to change(described_class, :count)
    user2 = described_class.find_for_google_oauth2(user_struct)
    expect(user2).to be_valid
  end
  it 'will create a new user if credentials valid' do
    user_struct = OpenStruct.new(
      info: {
        'email' => 'test_create_unique@example.com',
        'name' => 'Test User'
      }
    )
    expect do
      described_class.find_for_google_oauth2(user_struct)
    end.to change(described_class, :count).by(1)
  end
end
