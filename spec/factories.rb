FactoryGirl.define do
  factory :user do
  	sequence(:name)	  { |n| "U_name_#{n}" }
    sequence(:surname) { |n| "U_surname_#{n}" }
  	sequence(:email)	  { |n| "name_surname_#{n}@gmail.com" }
  end
  factory :category do
  	sequence(:name) { |n| "Category_#{n}" }
  end
  factory :event do
  	sequence(:name) { |n| "Event_#{n}" }
  	date "20.06.13" 
  	place "Somewhere"
  end
  factory :participation do
    score 100
    user
    category
    event
  end
end