class Event < ActiveRecord::Base
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :date, presence: true
  validates :hash_tag, length: {maximum: 100}
  validates :social_url, length: {maximum: 255}
  validates :photo_url, length: {maximum: 255}

  has_many :records
end
