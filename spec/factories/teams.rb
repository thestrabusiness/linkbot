FactoryGirl.define do
  factory :team do
    team_id "T#{SecureRandom.hex(4).upcase}"
    sequence(:name) { |n| "WHAK_#{n}, Inc."}
    active true
    sequence(:domain) { |n| "whak#{n}" }
    sequence(:token) { |n| "#{SecureRandom.uuid}#{n}" }
  end
end
