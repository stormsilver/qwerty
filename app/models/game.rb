class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rounds, :order => 'updated_at DESC'
  accepts_nested_attributes_for :rounds, :reject_if => proc { |attrs| attrs['kind'].blank? }
  has_many :texts
  
  def active_round
    rounds.where(:active => true).first || rounds.first
  end
  
  def self.find_active(user, phone)
    match = where(:phone_number => phone, :active => true, :users => {:id => user}).includes(:users).first
    unless match
      TwilioNumber.send_message("You do not have an active game for this number", user, nil, phone)
    end
    return match
  end

  def self.start_game(player1, player2)
    best_number =  self.get_game_number(player1, player2)
    if not best_number
      TwilioNumber.send_message("No game rooms could be found.  Please try again later.", player1)
      TwilioNumber.send_message("No game rooms could be found.  Please try again later.", player2)
      return
    end

    match = self.new :phone_number => best_number
    match.users << player1
    match.users << player2
    match.save
    return match
  end

  def self.kill_old_games(verbose=false)
    games = where(['active = 1 and updated_at < ?', DateTime.now - 15.minutes])
    games.each do |game|
      if verbose
        game.users.each do |user|
          TwilioNumber.send_message("This game of Text With Friends has been stopped due to lack of activity.", user, game)
        end
      end
      game.stop
    end
  end
  
  def start
    self.start_time = Time.now
    self.active = true
    self.waiting_for_players = false
    save
    # TODO: pusher
    
    PushMaster.generate_and_push('current-games')
    PushMaster.generate_and_push('current-players')
  end
  
  def stop
    self.end_time = Time.now
    self.active = false
    save
    
    PushMaster.generate_and_push('average-time-game')
    PushMaster.generate_and_push('current-games')
    PushMaster.generate_and_push('current-players')
  end

  def self.get_game_count_for_user(user)
    return where(:active => true, :users => {:id => user.id}).joins(:users).count
  end

  def self.get_game_number(player1, player2)
    TwilioNumber.get_numbers.each do |number|
      count_sql = <<-SQL
        select count(*) as count
          from games as g
          join games_users as gu on g.id = gu.game_id
          where g.active = 1 and g.phone_number = '#{number}' and gu.user_id in (#{player1.id}, #{player2.id})
          order by game_id
      SQL
      count = connection.select(count_sql).first['count']
      if count == 0
        return number
      end
    end
  end
end
