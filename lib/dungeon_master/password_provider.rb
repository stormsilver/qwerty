module DungeonMaster
  class PasswordProvider < DungeonMaster
    def self.get_password
      "chair"
    end
    
    
    def run
      if @game.users < 2
        # waiting for more players
        Twilo.send_message("Waiting for another player to join.", user)
        return
      end
      
      if @game.data.empty?
        # new game
        @game.start_time = Time.now
        @game.active = true
        @game.data[:password] = self.class.get_password
        
        # pick a clue giver
        @game.data[:clue_giver] = @game.users.first
        Twilio.send_message("The password is: #{@game.data[:password]}. Give your clue, 'skip' to get a new word, or 'stop' to end.", @game.data[:clue_giver])
        
        # other one is the guesser
        @game.data[:guesser] = @game.users.last
        Twilio.send_message("You are guessing the password. #{@game.data[:clue_giver].nickname} is thinking of a clue. 'stop' to end.", @game.data[:guesser])
        
        @game.save
      end
      
      
      case @text.body
      when 'skip'
      end
    end
  end
end