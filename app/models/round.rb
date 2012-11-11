class Round < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  has_many :texts
  serialize :data, Hash
  
  before_save :serialize_data
  after_find :deserialize_data
  # ghetto, but...
  after_save :deserialize_data
  
  def start
    self.start_time = Time.now
    self.active = true
    save
   # TODO: pusher
  end
  
  def stop
    self.end_time = Time.now
    self.active = false
    save
    
    PushMaster.generate_and_push('average-time-round')
    PushMaster.generate_and_push('average-sms')
  end
  
  def serialize_data
    case self.kind
    when 'password'
      [:guesser, :clue_giver, :turn].each do |user_object|
        self.data[user_object] = self.data[user_object].id if self.data[user_object]
      end
    end
  end
  
  def deserialize_data
    case self.kind
    when 'password'
      [:guesser, :clue_giver, :turn].each do |user_object|
        self.data[user_object] = User.find(self.data[user_object]) if self.data[user_object]
      end
    end
  end
end
