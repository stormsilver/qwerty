class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rounds
  accepts_nested_attributes_for :rounds, :reject_if => proc { |attrs| attrs['kind'].blank? }
  has_many :texts
  
  def active_round
    rounds.where(:active => true).first
  end
  
  def self.find_active(user, phone)
    match = where(:phone_number => phone, :active => true, :users => {:id => user}).joins(:users).first
    unless match
      TwilioNumber.send_message("You do not have an active game for this number", user, nil, phone)
    end
    return match
  end

  def self.find_waiting_or_start(user)
    matches = where(:waiting_for_players => true).order('created_at DESC').all
    if matches.any?
      users = matches.collect do |match|
        match.users
      end.flatten
      if users.include? user
        TwilioNumber.send_message("You are already waiting for a match.", user)
        return
      end
      match = matches.first
    else
      best_number = self.get_least_used_number(user)
      unless best_number
        return
      end
      match = self.new :phone_number => best_number
    end
    
    match.users << user
    match.save
    return match
  end
  
  def start
    start_time = Time.now
    active = true
    waiting_for_players = false
    save
    # TODO: pusher
    
    active_games = self.class.where(:active => true).all
    stat = Stat.where(:key => :concurrent_active_games).first
    stat = Stat.new(:key => :concurrent_active_games) unless stat
    if (stat.value < active_games.length)
      stat.value = active_games.length
      stat.save
      # TODO: pusher
    end
    
    active_users = active_games.collect{|g|g.users}.flatten.uniq
    stat = Stat.where(:key => :concurrent_active_users).first
    stat = Stat.new(:key => :concurrent_active_users) unless stat
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

  def self.get_least_used_number(user)
    count = where(:active => true, :users => {:id => user.id}).joins(:users).count
    if count > 2
      TwilioNumber.send_message("You are already in the maximum number of games.", user)
      return
    end
    sql = <<-SQL
      SELECT `games`.*, count(*) AS cnt 
      FROM `games` 
      INNER JOIN `games_users` ON `games_users`.`game_id` = `games`.`id` 
      INNER JOIN `users` ON `users`.`id` = `games_users`.`user_id` 
      WHERE `games`.active = 1 AND (`users`.`id` != #{user.id}) 
      GROUP BY `games`.phone_number 
      ORDER BY cnt DESC;
    SQL
    results = find_by_sql(sql)
    if results.any?
      return results.first.phone_number
    else
      return TwilioNumber.first.phone_number
    end
  end
end
