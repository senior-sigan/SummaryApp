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
              emit(cat.name,1);
            });
          }
        });
      }
    }
    reduce = %Q{
      function(key, values){
        return Array.sum(values);
      }
    }
    Event.map_reduce(map, reduce).out(replace: 'calculated_categories').to_a
  end

  def participants_count
    self['value']
  end
end
