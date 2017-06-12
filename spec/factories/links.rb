FactoryGirl.define do
  factory :link do
    url 'www.google.com'
    slug SecureRandom.hex(3)
  end
end
