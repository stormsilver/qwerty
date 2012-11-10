class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rounds
  accepts_nested_attributes_for :rounds, :reject_if => proc { |attrs| attrs['kind'].blank? }
  has_many :texts
  
  serialize :data, Hash
  
  def active_round
    rounds.where(:active => true).first
  end
  
  def self.find_match(user)
    match = where(:waiting_for_players => true).order('created_at DESC').first
    
    unless match
      match = self.new
    end
    
    match.users << user
    match.save
    match
  end
end
