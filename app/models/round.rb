class Round < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  has_many :texts
  serialize :data, Hash
  
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
end
