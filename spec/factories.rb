FactoryGirl.define do
  factory :user do
  	sequence(:name)	  { |n| "U_name_#{n}" }
    sequence(:surname) { |n| "U_surname_#{n}" }
  	sequence(:email)	  { "#{name}.#{surname}@gmail.com" }
  end
  factory :event do
  	sequence(:name) { |n| "Event_#{n}" }
  	date "20.06.13" 
  	place "Somewhere"
  end
  factory :registration do
    user
    event 
    was true
    newcomer true
  end
  factory :good_file, class: ActionDispatch::Http::UploadedFile do
    ignore do
      filename "event.csv"
      content_type "text/csv"
      tempfile File.new("#{Rails.root}/spec/files/event.csv")
    end
    initialize_with {new({
      filename: filename,
      content_type: content_type,
      tempfile: tempfile})}
  end
  factory :next_good_file, class: ActionDispatch::Http::UploadedFile do
    ignore do
      filename "next_event.csv"
      content_type "text/csv"
      tempfile File.new("#{Rails.root}/spec/files/next_event.csv")
    end
    initialize_with {new({
      filename: filename,
      content_type: content_type,
      tempfile: tempfile})}
  end
end