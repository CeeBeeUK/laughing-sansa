FactoryGirl.define do
  factory :participating_player do
    association :player, factory: 'user'
    event
    predicted_uk_score 1
  end

end
