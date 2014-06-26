# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "summaryapp_#{n}@gmail.com" }
    sequence(:authentication_token) { |n| "token_#{n}" }
    approved false
  end
end
