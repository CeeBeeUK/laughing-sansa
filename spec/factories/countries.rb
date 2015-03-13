FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "United Kingdom #{n}" }
  end
end
