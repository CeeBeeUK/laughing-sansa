FactoryGirl.define do
  factory :event do
    sequence(:year)
    host_city 'london'
    active false
    association :country
    real_winner_id nil
    real_score nil
    real_player_id nil
    real_player_name nil
    home_winner_id nil
    home_score nil
    home_player_id nil
    home_player_name nil
    status nil
  end
end
