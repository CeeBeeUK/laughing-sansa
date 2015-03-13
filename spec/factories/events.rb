FactoryGirl.define do
  factory :event do
    sequence(:year)
    host_city 'london'
    active false
    association :country
    real_winner_id nil
    real_score nil
    association :real_player, factory: 'user'
    real_player_name nil
    home_winner_id nil
    home_score nil
    association :home_player, factory: 'user'
    home_player_name nil
    status nil
  end
end
