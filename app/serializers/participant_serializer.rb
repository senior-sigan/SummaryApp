class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :gravatar, :categories, :score, :skip, :was

  def id
    object.to_param
  end

  def name
    object.name.capitalize
  end

  def surname
    object.surname.capitalize
  end

  def gravatar
    object.gravatar(50)
  end
end