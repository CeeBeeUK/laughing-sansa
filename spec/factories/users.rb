FactoryBot.define do
  factory :user do
    role { 'user' }
    name { 'test user' }
    first_name { 'test' }
    last_name { 'user' }
    sequence(:email) { |n| "user#{n}@example.com" }
    factory :admin_user do
      role { 'admin' }
      sequence(:email) { |n| "admin#{n}@example.com" }
    end
  end
end
