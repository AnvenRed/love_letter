class GameMaster

  def initialize(game)
    @game = game
  end

  def game_over?
    if @game.in_play.length == 1
      @game.game_over = true
      return true
    end
    return false
  end

  def add_player(player)
    @game.add_player(player)
  end

  def get_players()
    @game.players.keys
  end

  def get_player_hands()
    returned = {}
    @game.players.each_value do |player|
      returned[player.name] = player.hand
    end
    return returned
  end

  def start_game()
    @game.players.each_value do |player|
      player_draws_card(player)
    end
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

  def get_current_state
    @game.get_current_state
  end

end
