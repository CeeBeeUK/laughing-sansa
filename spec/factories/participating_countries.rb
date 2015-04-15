FactoryGirl.define do
  factory :participating_country do
    country
    event
    # add_attribute :position, 1
    sequence(:position) { |n| "#{n}" }
    association :player, factory: 'user'
    real_final_score nil
    home_final_score nil
  end
end
