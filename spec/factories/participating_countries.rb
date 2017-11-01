FactoryBot.define do
  factory :participating_country do
    country
    event
    sequence(:position)
    association :player, factory: 'user'
    real_final_score nil
    home_final_score nil
  end
end
