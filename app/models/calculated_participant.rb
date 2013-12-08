class CalculatedParticipant
  include Mongoid::Document

  field :_id, type: String
  field :value, type: Hash
  index 'value.categories.name' => 1
  
  scope :for_category, ->(category) { where('value.categories.name' => category.id).order_by('value.categories.score DESC') }
  scope :order_by_score, -> { order_by('value.score DESC') }
  scope :order_by_goodness, -> { order_by('value.goodness DESC') }

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
    value['categories']
  end
  
  def score
    value['score'] || 0
  end

  def score_for_category(category)
    categories.each do |cat|
      return cat['score'] if cat['name'].eql?(category.id)
    end
    0
  end
  
  def event
    value['event']
  end

  def was
    value['was']
  end

  def skip
    value['skip']
  end

  def self.recalculate!
    map = %Q{
      function(){
        var event = this;

        this.participants.forEach(function(part){
          var value = {categories: {}, skip: 0, was: 0, score: 0, event: {id: event._id, date: event.date}};

          for (var key in part) {
            if ('categories' != key && '_id' != key && 'email' != key && 'event' != key){
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
              value.score += cat.score;
            });
          }
          emit(part.email, value);
        });
      }
    }

    reduce = %Q{
      function(key, values){
        var value = {name: '', surname: '', score: 0, was: 0, skip: 0, goodness: 0, categories: {}, event: {id: null, date: null}};
        values.forEach(function(val){
          value.name = val.name;
          value.surname = val.surname;
          value.was += val.was;
          value.skip += val.skip;
          value.score += val.score;
          if ( !value.event.date ) {
            value.event.id = val.event.id;
            value.event.date = val.event.date;
          } else {
            if ( val.event.date < value.event.date){
              value.event.id = val.event.id;
              value.event.date = val.event.date;
            } 
          }
          for (var key in val) {
            if ('name' != key && 'surname' != key && 'was' != key && 'skip' != key && 'categories' != key && 'score' != key && 'event' != key){
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
        var temp = [];
        for (var key in value.categories) {
          temp.push({name: key, score: value.categories[key]});
        }
        value.categories = temp;
        return value;
      }
    }

    Event.map_reduce(map,reduce).out(replace: 'calculated_participants').finalize(finalize).to_a
  end
end
