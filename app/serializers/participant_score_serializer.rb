class ParticipantScoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :gravatar, :score

  def id
    object.to_param
  end

  def gravatar
    object.gravatar(50)
  end

  def score
    object.score_for_category(scope)
  end
end
