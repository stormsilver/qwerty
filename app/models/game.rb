class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rounds
  has_many :texts
end
