FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Korben_#{n}"}
    last_name "Dallas"
    association :active_team, factory: :team
    with_slack_account
  end

  trait :with_slack_account do
    after :create do |object, _|
      create(:slack_account, user: object, team: object.active_team)
    end
  end
end
