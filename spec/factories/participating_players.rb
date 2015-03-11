FactoryGirl.define do
  factory :participating_player do
    association :player, factory: 'user'
    association :event
    predicted_uk_score 1
    after(:build) do |pp|
      pp.event.active!
    end
  end
end
