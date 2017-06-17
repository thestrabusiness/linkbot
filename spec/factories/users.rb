FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Korben_#{n}"}
    last_name "Dallas"
    sequence(:email) { |n| "kdallas_#{n}@multipass.net"}
    sequence(:slack_id) { |n| "U#{SecureRandom.hex(4).upcase}#{n}" }
    association :active_team, factory: :team
  end
end
