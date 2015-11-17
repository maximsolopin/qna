FactoryGirl.define do
  factory :user do
    display_name 'Test User'
    sequence(:email)  { |n| "user#{n}@test.com" }
    password '12345678'
    password_confirmation '12345678'
  end
end
