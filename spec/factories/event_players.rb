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
    trait :with_scores do
      transient do
        number_of_scores 3
      end

      after :build do |this, evaluator|
        FactoryGirl.create_list :event_player_score, evaluator.number_of_scores, event_player: this
      end
    end
  end
end
