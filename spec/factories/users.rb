FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Korben_#{n}"}
    last_name "Dallas"
    sequence(:email) { |n| "kdallas_#{n}@multipass.net"}
    slack_id "U#{SecureRandom.hex(4).upcase}"
    team
  end
end
