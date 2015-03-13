FactoryGirl.define do
  factory :participating_player do
    association :player, factory: 'user'
    association :event
    predicted_uk_score 1
    after(:build) do |pp|
      pp.event.active!
    end

    factory :invalid_pp do
      predicted_uk_score nil
    end
  end
end
