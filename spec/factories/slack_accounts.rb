FactoryGirl.define do
  factory :slack_account do
    sequence(:email) { |n| "kdallas_#{n}@multipass.net"}
    sequence(:slack_id) { |n| "U#{SecureRandom.hex(4).upcase}#{n}" }

    trait :with_user do
      association :user, factory: :user
    end
  end
end
