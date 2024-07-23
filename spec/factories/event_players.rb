FactoryBot.define do
  factory :event_player do
    player factory: 'user'
    event
    predicted_uk_score { 1 }

    transient do
      skip_event_activate { false }
    end

    trait :skip_event_activate do
      transient do
        skip_event_activate { true }
      end
    end

    after(:build) do |ep, evaluator|
      ep.event.active! unless evaluator.skip_event_activate
    end

    trait :invalid_pp do
      predicted_uk_score { nil }
    end
    trait :with_scores do
      transient do
        number_of_scores { 3 }
      end

      after :build do |this, evaluator|
        FactoryBot.create_list :event_player_score, evaluator.number_of_scores, event_player: this
      end
    end
  end
end
