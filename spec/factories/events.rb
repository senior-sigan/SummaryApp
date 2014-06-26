FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event_#{n}" }
    date DateTime.now
    photo_url 'http://24.media.tumblr.com/tumblr_m1thntif9p1qzex9io1_500.png'
    social_url 'http://thecatapi.com/'
    hash_tag '#summaryapp'
  end
end
