class Text < ActiveRecord::Base
  belongs_to :round
  belongs_to :game
  belongs_to :user
end
