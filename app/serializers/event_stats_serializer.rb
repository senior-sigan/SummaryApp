class EventStatsSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :newcomers, :newcomer_ratio, :real_ratio, :users

  def name
    object.hash_tag || object.name[0..10]
  end

  def id
    object.id.to_s
  end

  def newcomers
    object.newcomers.count.to_f
  end

  def real_users
    object.participants.real.count.to_f
  end

  def users
    object.participants.count.to_f
  end
#TODO bug in necomers_ratio > 100
  def newcomer_ratio
    100 * unless users.zero?
      newcomers /  real_users
    else
      0
    end
  end

  def real_ratio
    100 * unless users.zero?
      real_users / users
    else
      0
    end
  end
end