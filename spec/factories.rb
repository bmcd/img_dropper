FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "bradmcdermott+#{n}@gmail.com" }
    f.password "password"
    f.password_confirmation "password"
  end
end