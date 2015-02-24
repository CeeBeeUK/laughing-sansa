FactoryGirl.define do
  factory :user do
    role 'user'
    sequence(:email){|n| "user#{n}@example.com" }
    name 'test user'
    first_name 'test'
    last_name 'user'
    display_name nil
    factory :admin_user do
      role 'admin'
      sequence(:email){|n| "admin#{n}@example.com" }
    end
  end
end