require_relative './game_classes/LoveLetter.rb'
require_relative './game_classes/Player.rb'
require_relative './game_classes/GameMaster.rb'

# player1 = Player.new("Player1")
# player1.draw("Guard")
# player1.draw("Priest")
#
# puts player1.play_guard("Player2","Priest")
# puts player1.play_priest("Player2")

sep = "-------------------------------------------"

game = LoveLetter.new
gm = GameMaster.new(game)
player1 = Player.new("Player1")
player2 = Player.new("Player2")
player3 = Player.new("Player3")

gm.add_player(player1)
gm.add_player(player2)
gm.add_player(player3)

puts sep
puts gm.get_players
puts sep
gm.start_game
gm.get_player_hands
puts sep
player1.draw("Guard")
player_action = {
  "Initiating Player" => "Player1",
  "Target Player" => "Player2",
  "Card Played" => "Guard",
  "Card Played Requirement" => player2.hand[0]
}
puts "Player1 Hand: #{player1.hand}"
puts "Player2 Hand: #{player2.hand}"
puts "Player1 Plays Guard and guesses that Player2 has #{player2.hand}"
player_return = gm.player_plays_card(player_action)
puts "Player1 Return: #{player_return["Initiating Player Return"]}"
puts "Player2 Return: #{player_return["Target Player Return"]}"
puts "Player1 Hand is now: #{player1.hand}"
puts game.last_card_played
