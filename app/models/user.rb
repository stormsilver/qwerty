  class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :scores
  has_many :texts
  
  after_create do
    PushMaster.generate_and_push('players-count')
  end

  def self.find_or_create(phone)
    user = where(:phone_number => phone).first
    is_new = false
    unless user
      user = self.new(:phone_number => phone)
      user.nickname = self.generate_nickname
      user.area_code = phone[2,3].to_i
      user.save

      TwilioNumber.send_message("Welcome to QWERTY, #{user.nickname}! #{ApplicationConfig[:main_menu]}", user)
      is_new = true
    end

    return user, is_new
  end

  def self.find_next_two_waiting_users
    users = where("queue_time IS NOT NULL").order("queue_time DESC").limit(2)
    user_list = []
    users.each do |user|
      user_list.push(user)
    end

    return user_list[0], user_list[1]
  end

  def self.generate_nickname
  	return Randgen.name
  end

  def get_total_score
    sql = "SELECT sum(amount) as sum from scores WHERE user_id = #{self.id};"
    results = ActiveRecord::Base.connection().execute(sql)
    score = results.first[0] or 0
  end

  def queue
    if self.queue_time
      TwilioNumber.send_message("We are already on a quest to find you an opponent. Please be patient.", self)
      return false
    else
      count = Game.get_game_count_for_user(self)
      if count > 2
        TwilioNumber.send_message("You are already in the maximum number of games.", self)
        return
      end
      self.queue_time = Time.new
      self.save
      return true
    end
  end
end
