class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rounds
  accepts_nested_attributes_for :rounds, :reject_if => proc { |attrs| attrs['kind'].blank? }
  has_many :texts
  
  def active_round
    rounds.where(:active => true).first
  end
  
  def self.find_or_create(user)
    match = where(:waiting_for_players => true).order('created_at DESC').first
    
    unless match
      match = self.new
    end
    
    if match.users.include? user
      false
    else
      match.users << user
      match.save
      match
    end
  end
  
  def start
    start_time = Time.now
    active = true
    save
    # TODO: pusher
    
    active_games = self.where(:active => true).find
    stat = Stat.where(:key => :concurrent_active_games)
    if (stat.value < active_games.length)
      stat.value = active_games.length
      stat.save
      # TODO: pusher
    end
    
    active_users = active_games.users.uniq!
    stat = Stat.where(:key => :concurrent_active_users)
    if (stat.value < active_users.length)
      stat.value = active_users.length
      stat.save
      # TODO: pusher
    end
  end
  
  def stop
    end_time = Time.now
    active = false
    save
  end
end
