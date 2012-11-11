class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :scores
  has_many :texts

  def self.find_or_create(phone)
  	user = where(:phone_number => phone).first
  	unless user
  		user = self.new(:phone_number => phone)
  		user.nickname = self.generate_nickname
  		user.area_code = phone[2,3].to_i
  		user.save
  	end

  	return user
  end

  def self.generate_nickname
  	return Randgen.name
  end
end
