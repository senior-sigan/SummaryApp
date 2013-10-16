class CalculatedCategory
  include Mongoid::Document

  field :_id, type: Moped::BSON::ObjectId
  field :value, type: Hash

  def self.recalculate
    map = %Q{
      function(){
        this.participants.forEach(function(part){
          part.categories.forEach(function(cat){
            emit(cat.name,1)
          });
        });
      }
    }
    reduce = %Q{
      function(key, values){
        value = 0;
        return Array.sum(values);
      }
    }
    Event.map_reduce(map, reduce).out(replace: 'calculated_category').to_a
  end
end
