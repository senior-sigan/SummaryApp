class Join
  def initialize(*structs)
    @structs = structs
  end

  def by(column)
    result = {}
    @structs.each do |struct|
      struct.each do|entity|
        key = entity[column]
        result[key] ||= {}
        entity.each_pair do |k,v| 
          result[key][k] = v
        end
      end
    end

    result
  end
end