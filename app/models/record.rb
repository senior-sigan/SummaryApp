class Record < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 100}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { scope: :event, case_sensitive: false }
  validates :name, presence: true, length: {maximum: 50}
  validates :surname, presence: true, length: {maximum: 50}

  default_scope { order 'surname ASC'}

  before_save do
    self.email = email.downcase
    self.name = name.downcase
    self.surname = surname.downcase
  end

  belongs_to :event, counter_cache: true

  def toggle_presence
    if presence
      update_attribute :presence, false
    else
      update_attribute :presence, true
    end
  end

  def klass
    presence? ? 'btn-success' : 'btn-danger'
  end
end
