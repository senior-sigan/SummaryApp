class CalculatedParticipant
  include Mongoid::Document

  field :_id, type: String
  field :value, type: Hash

  def to_param
    URI.escape Base64.encode64(email)
  end

  def self.find(params)
    params = URI.unescape Base64.decode64(params)
    super
  end

  def gravatar(size)
    size ||= 50
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(id)}?size=#{size}"
  end

  def name
    value['name']
  end
  def surname
    value['surname']
  end
  def email
    id
  end
  def categories
    value['categories'] || []
  end

  def self.recalculate!
    map = %Q{
      function(){
        var value = {};
        this.participants.forEach(function(part){
          value = {categories: {}, skip: 0, was: 0};
          for (var key in part) {
            if ('categories' != key && '_id' != key && 'email' != key){
              value[key] = part[key];
            }
          }
          if (part.was == true){
            value.skip = 0;
            value.was = 1;
          } else {
            value.skip = 1;
            value.was = 0;
          }
          if (part.categories){
            part.categories.forEach(function(cat){
              value.categories[cat.name] = cat.score; 
            });
          }
          emit(part.email, value);
        });
      }
    }

    reduce = %Q{
      function(key, values){
        var value = {name: '', surname: '', was: 0, skip: 0, goodness: 0, categories: {}};
        values.forEach(function(val){
          value.name = val.name;
          value.surname = val.surname;
          value.was += val.was;
          value.skip += val.skip;
          for (var key in val) {
            if ('name' != key && 'surname' != key && 'was' != key && 'skip' != key && 'categories' != key){
              if (value[key]){
                value[key] += val[key];
              } else {
                value[key] = val[key];
              }
            }
          }
          if (val.categories){
            for (var cat_name in val.categories){
              if (!value.categories[cat_name]){
                value.categories[cat_name] = val.categories[cat_name];
              } else {
                value.categories[cat_name] += val.categories[cat_name];
              }
            }
          }
        });
        return value;
      }
    }

    finalize = %Q{
      function(key,value){
        var all = value.was + value.skip;
        if (all == 0){
          value.goodness = 0;
          return value;
        }
        value.goodness = value.was*value.was / all;
        return value;
      }
    }

    Event.map_reduce(map,reduce).out(replace: 'calculated_participants').finalize(finalize).to_a
  end
end
