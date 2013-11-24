class CalculatedCategory
  include Mongoid::Document

  field :_id, type: Moped::BSON::ObjectId
  field :value, type: Hash

  def self.recalculate!
    map = %Q{
      function(){
        this.participants.forEach(function(part){
          if (part.categories){  
            part.categories.forEach(function(cat){
              emit(cat.name,part.email);
            });
          }
        });
      }
    }
    reduce = %Q{
      function(key, values){
        var value = {participants: []};
        value.participants = values;
        return value;
      }
    }
    Event.map_reduce(map, reduce).out(replace: 'calculated_categories').to_a
  end

  def participants_count
    value['participants'].count
  end

  def participants
    value['participants']
  end
end
