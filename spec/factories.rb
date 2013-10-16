FactoryGirl.define do
  factory :participant do
  	sequence(:name)	  { |n| "U_name_#{n}" }
    sequence(:surname) { |n| "U_surname_#{n}" }
  	sequence(:email)	  { "#{name}.#{surname}@gmail.com" }
    was true

    factory :participant_with_categories do
      categories { FactoryGirl.build_list(:category, 5) }
    end

  end

  factory :event do
  	sequence(:name) { |n| "Event_#{n}" }
  	date "20.06.13" 
  	place "Somewhere"

    factory :event_with_participants do
      participants { FactoryGirl.build_list(:participant, 5) }
    end

    factory :full_embedded_event do
      participants { FactoryGirl.build_list(:participant_with_categories, 5) }
    end
  end

  factory :category do
    sequence(:name) { |n| "category_#{n}" }
    score 10
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
      tempfile: tempfile})
    }
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
      tempfile: tempfile})
    }
  end

end