class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :scores
  has_many :texts

  def self.find_or_create(phone)
  	user = where(:phone_number => phone).first
    is_new = false
  	unless user
  		user = self.new(:phone_number => phone)
  		user.nickname = self.generate_nickname
  		user.area_code = phone[2,3].to_i
  		user.save

      TwilioNumber.send_message("Welcome to QWERTY! #{ApplicationConfig[:main_menu]}")
      is_new = true
  	end

  	return user, is_new
  end

  def self.generate_nickname
  	return Randgen.name
  end

  def get_total_score
    sql = "SELECT sum(amount) as sum from scores WHERE user_id = #{self.id};"
    results = ActiveRecord::Base.connection().execute(sql)
    score = results.first[0] or 0
  end
end
