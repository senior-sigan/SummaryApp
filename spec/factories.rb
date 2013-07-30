FactoryGirl.define do
  factory :user do
  	sequence(:name)	  { |n| "name #{n}" }
    sequence(:surname) { |n| "surname #{n}" }
  	sequence(:email)	  { |n| "name_surname_#{n}@gmail.com" }
  end
end