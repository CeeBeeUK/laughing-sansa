FactoryBot.define do
  factory :event_player_score do
    association :event_player
    association :participating_country
    score 1
    best_wail false
    fattest false
    wackiest false
    notes 'My notes'
  end
end
