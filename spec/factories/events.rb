FactoryBot.define do
  factory :event do
    sequence(:year)
    host_city { 'london' }
    active { false }
    country
    real_winner_id { nil }
    real_score { nil }
    real_player factory: 'user'
    real_player_name { nil }
    home_winner_id { nil }
    home_score { nil }
    home_player factory: 'user'
    home_player_name { nil }
    status { nil }

    trait :with_countries do
      transient do
        number_of_countries { 3 }
      end

      after :create do |event, evaluator|
        FactoryBot.create_list :participating_country, evaluator.number_of_countries, event: event
      end
    end
  end
end
