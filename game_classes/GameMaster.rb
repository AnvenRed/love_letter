class GameMaster

  def initialize(game)
    @game = game
  end

  def add_player(player)
    @game.add_player(player)
  end

  def execute_player_action(player_action)
    action_type = player_action["Action Type"]
    case action_type
    when "Draw"
      player = @game.players[player_action["Initiating Player"]]
      player_draws_card(player)
      @game.get_current_state
    when "Play"
      player_plays_card(player_action)
      @game.get_current_state
    else
      "Invalid Action"
    end
  end

  def player_draws_card(player)
    player.draw(@game.get_card)
  end

  def player_plays_card(player_action)
    card_played = player_action["Card Played"]
    player = @game.players[player_action["Initiating Player"]]
    player.discard(card_played)
    @game.execute_card_action(player_action)
  end

end