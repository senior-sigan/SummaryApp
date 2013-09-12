class Registration
  include Mongoid::Document
  field :was, type: Boolean, default: true
  field :newcomer, type: Boolean

  belongs_to :event
  belongs_to :user
  has_many :participations, dependent: :delete

  index({user: 1, event: 1}, {unique: true})

  scope :fakes, where(was: false)
  scope :reals, where(was: true)

  validates :was,
  	presence: true
  validates :user,
    presence: true 
  validates :event,
    presence: true
  validates :user_id,
    uniqueness: { scope: :event_id }
  validates :newcomer,
    presence: true

  def categories
  	Category.in(id: participations.distinct(:category_id))
  end
  def score
  	participations.sum(:score)
  end
  def self.score
    #Map reduce - вычислить сразу все. автоматически сгруппировать по user_ids посчитать score и отсортировать
    map = '
      function(){
        emit(this.user.id,this.score);
      }
    '
    reduce = '
      function(key, values){
        return Array.sum(values);
      }
    '
    Participation.map_reduce(map, reduce).out(inline: true).find()
  end
  def self.activity
    map = %Q{
      function(){
        if (this.was){
          emit(this.user_id,{was: 1, skip: 0});
        } else {
          emit(this.user_id,{was: 0, skip: 1});
        }
      }
    }
    reduce = %Q{
      function(key,values){
        var res = {was: 0, skip: 0};
        values.forEach(function(v){
          res.was += v.was;
          res.skip += v.skip;
        });
        return res;
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
    Registration.map_reduce(map, reduce).out(inline: true).finalize(finalize)
  end
  def participate!(category, score)
    part = participations.find_or_initialize_by(category: category)
    part.score = score
    part.save
  end
  def unparticipate!
    participations.delete_all
  end
end

