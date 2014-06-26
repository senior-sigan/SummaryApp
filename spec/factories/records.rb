FactoryGirl.define do
  factory :record do
    sequence(:name)   { |n| "U_name_#{n}" }
    sequence(:surname) { |n| "U_surname_#{n}" }
    sequence(:email)    { "#{name}.#{surname}@gmail.com" }
    meta "#{{hello: :world}.to_json}"
  end
end
