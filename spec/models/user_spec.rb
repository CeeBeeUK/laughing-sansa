require 'spec_helper'

describe User, :type => :model do

  let(:user)          { FactoryGirl.build :user }
  let(:admin_user)    { FactoryGirl.build :admin_user }

  it 'should pass factory build' do
    expect(user).to be_valid
  end

  describe 'validations' do
    it 'should require an email' do
      user.email = nil
      expect(user).to be_invalid
    end

    it 'should require a valid email' do
      user.email = 'testemail'
      expect(user).to be_invalid
    end

    it 'should require a unique email' do
      User.create({
                    email: 'test@duplicate.com',
                    role: 'user'
                  })
      duplicate = User.new({
                             role: 'admin',
                             email: 'test@duplicate.com'
                           })
      expect(duplicate).to be_invalid
    end

    it 'should require a non-nil role' do
      user.role = nil
      expect(user).to be_invalid
      expect(user.errors[:role]).to eq ["can't be blank"]
    end

    it 'should require a valid role' do
      user.role = 'student'
      expect(user).to be_invalid
      expect(user.errors[:role]).to eq ['student is not a valid role']
    end

    it 'should return the oaauth first name if display name empty' do
      user.display_name = nil
      expect(user.display_name).to eql('test')
    end

    it 'should return the display name if explicitly set' do
      user.display_name = 'wibble'
      expect(user.display_name).to eql('wibble')
    end
  end
  describe '@display_name_set?' do
    it 'should respond true if a name is explicitly set' do
      user.display_name='CeeBee'
      expect(user.display_name_set?).to be true
    end

    it 'should respond false if not admin user' do
      user.display_name = nil
      expect(user.display_name_set?).to be false
      user.display_name = ''
      expect(user.display_name_set?).to be false
    end
  end
  describe '@admin?' do
    it 'should respond true if admin user' do
      expect(admin_user.admin?).to be true
    end

    it 'should respond false if not admin user' do
      expect(user.admin?).to be false
    end
  end
end
