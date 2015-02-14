FactoryGirl.define do
  factory :user do
    role 'user'
    sequence(:email){|n| "user#{n}@example.com" }
    factory :admin_user do
      role 'admin'
      email 'admin@example.com'
    end
  end
end