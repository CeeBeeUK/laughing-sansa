FactoryGirl.define do
  factory :participating_country do
    country
    event
    add_attribute :sequence, 1
    association :player, factory: 'user'
    real_final_score nil
    home_final_score nil
  end
end
