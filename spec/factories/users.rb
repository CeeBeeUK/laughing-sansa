FactoryGirl.define do
  factory :user do
    role 'user'
    sequence(:email){|n| "user#{n}@example.com" }
    factory :admin_user do
      role 'admin'
      sequence(:email){|n| "admin#{n}@example.com" }
    end
  end
end