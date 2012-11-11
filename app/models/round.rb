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
    
    avg = connection.select_value("SELECT AVG(`end_time` - `start_time`) FROM rounds WHERE `start_time` IS NOT NULL AND `end_time` IS NOT NULL")
    PushMaster.push('average-time-round', {:average => avg})
    
    avg = connection.select_value("SELECT AVG(foo.cnt) FROM (SELECT count(*) AS cnt FROM texts GROUP BY texts.game_id) AS foo")
    PushMaster.push('average-sms', {:average => avg.to_f})
  end
end
