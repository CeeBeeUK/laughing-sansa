FactoryGirl.define do
  factory :event_player do
    association :player, factory: 'user'
    association :event
    predicted_uk_score 1
    after(:build) do |ep|
      ep.event.active!
    end

    factory :invalid_pp do
      predicted_uk_score nil
    end
  end
end
