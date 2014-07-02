class ParticipantPresenter
  def initialize(model)
    @model = model
  end

  def id
    @model.id
  end

  def name
    @model.name.capitalize
  end

  def surname
    @model.surname.capitalize
  end

  def full_name
    "#{surname} #{name}"
  end

  def email
    @model.email
  end

  def hidden_email
    email.split('@').first
  end

  def photo(size = 50)
    Avatar.new(@model.email).url(size)
  end

  def participations
    @model.participations || 0
  end

  def self.build(models)
    models.map do |model|
      ParticipantPresenter.new(model)
    end
  end
end