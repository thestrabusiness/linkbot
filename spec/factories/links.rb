FactoryGirl.define do
  factory :link do
    sequence(:url) {|n| "www.link#{n}.com"}
    slug SecureRandom.hex(3)
  end
end
