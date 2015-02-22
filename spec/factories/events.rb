FactoryGirl.define do
  factory :event do
    sequence(:year)
    host_city 'london'
    active false
    country
  end

end
