class Round < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  has_many :texts
  serialize :data, Hash
  
  def start
    start_time = Time.now
    active = true
    save
   # TODO: pusher
  end
  
  def stop
    end_time = Time.now
    active = false
    save
    # TODO: pusher
  end
end
