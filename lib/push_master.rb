class PushMaster
  def self.generate_and_push(key)
    push(key, generate(key))
  end
  
  def self.generate(key)
    statistics[key].call
  end
  
  
  def self.push(key, data)
    Rails.logger.info("PUSHER: #{key} - #{data.inspect}")
    Pusher['qwerty'].trigger(key, data)
  end
  
  
  
  
  def self.statistics
    @@statistics
  end
  
  @@statistics = {
    'current-games' => Proc.new do
      active_games = Game.where(:active => true).all
      stat = Stat.where(:key => :max_concurrent_active_games).first
      stat = Stat.new(:key => :max_concurrent_active_games) unless stat
      if (stat.value < active_games.length)
        stat.value = active_games.length
        stat.save
      end
      {:count => active_games.length, :record => stat.value}
    end,
    'current-players' => Proc.new do
      active_games = Game.where(:active => true).all
      active_users = active_games.collect{|g|g.users}.flatten.uniq
      stat = Stat.where(:key => :max_concurrent_active_users).first
      stat = Stat.new(:key => :max_concurrent_active_users) unless stat
      if (stat.value < active_users.length)
        stat.value = active_users.length
        stat.save
      end
      {:count => active_users.length, :record => stat.value}
    end,
    'average-time-game' => Proc.new do
      {:average => ActiveRecord::Base.connection.select_value("SELECT AVG(`end_time` - `start_time`) FROM games WHERE `start_time` IS NOT NULL AND `end_time` IS NOT NULL")}
    end,
    'average-time-round' => Proc.new do
      {:average => ActiveRecord::Base.connection.select_value("SELECT AVG(`end_time` - `start_time`) FROM rounds WHERE `start_time` IS NOT NULL AND `end_time` IS NOT NULL")}
    end,
    'average-sms' => Proc.new do
      {:average => ActiveRecord::Base.connection.select_value("SELECT AVG(foo.cnt) FROM (SELECT count(*) AS cnt FROM texts GROUP BY texts.game_id) AS foo").to_f}
    end,
    'sms-count' => Proc.new do
      {:count => Text.count}
    end,
    'players-count' => Proc.new do
      {:count => User.count}
    end,
    'average-score' => Proc.new do
      {:average => Score.connection.select_value("SELECT AVG(`amount`) FROM scores WHERE `user_id` IS NOT NULL AND `round_id` IS NOT NULL").to_f}
    end
  }
  
end