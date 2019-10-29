class LoveLetter

  @@card_values = {
    "Guard" => 1,
    "Priest" => 2,
    "Baron" => 3,
    "Handmaid" => 4,
    "Prince" => 5,
    "King" => 6,
    "Countess" => 7,
    "Princess" => 8
  }

  @@unshuffledDeck = ["Guard"]*5 + ["Priest"]*2 + ["Baron"]*2 + ["Handmaid"]*2 + ["Prince"]*2 + ["King"]*2 + ["Countess"] + ["Princess"]

  attr_accessor :deck, :players, :card_values, :removed_card, :in_play, :last_card_played

  def initialize()
    shuffled = @@unshuffledDeck.shuffle
    @removed_card = shuffled.pop
    @deck = shuffled
    @players = {}
    @in_play = []
    @discarded = []
    @card_values = @@card_values
    @game_over = false
    @last_card_played = ""
  end

  def get_current_state()
    {
      "Game State" => get_game_state(),
      "Player States" => get_player_states()
    }
  end

  def get_game_state()
    {
      "Cards Left" => @deck.length,
      "Discard Pile" => @discarded,
      "Game Over" => @game_over ? "True" : "False",
      "Removed Card" => @removed_card,
      "Last Played Card" => @last_card_played
    }
  end

  def get_player_states()
    returned = []
    @players.each do |key, value|
      returned.push(get_player_state(value))
    end
    returned
  end

  def get_player_state(player)
    {
      "Name" => player.name,
      "In Game" => player.in_game,
      "Hand" => player.hand,
      "Is Turn" => player.is_turn
    }
  end

  def add_player(player)
    @players[player.name] = player
    @in_play.push(player.name)
  end

  def get_card()
    @deck.pop
  end

  def create_status_change(player,new_status)
    {
      "Player" => player,
      "Status" => new_status
    }
  end

  def player_is_out(player_name)
    player_obj = @players[player_name]
    player_obj.in_game = false
    player_obj.status = "Out"
    @in_play.delete(player_name)
  end

  def change_status(status_change)
    player = status_change["Player"]
    new_status = status_change["Status"]
    @players[player].status = new_status
    if new_status == "Out"
      @in_play -= [player]
    end
    status_change
  end

  def execute_card_action(player_action)
    card_played = player_action["Card Played"]
    if player_action.key?("Target Player") and card_played != "Handmaid"
      target_player_name = player_action["Target Player"]
      target_player_obj = @players[target_player_name]
      if target_player_obj.status == "Protected"
        return {
          "Initiating Player Return" => "That player is protected by the Handmaid you fool"
        }
      end
    end
    @discarded.push(card_played)
    @last_card_played = card_played
    case card_played
    when "Guard"
      guard_played(player_action)
    when "Priest"
      priest_played(player_action)
    when "Baron"
      baron_played(player_action)
    when "Handmaid"
      handmaid_played(player_action)
    when "Prince"
      prince_played(player_action)
    when "King"
      king_played(player_action)
    when "Countess"
    when "Princess"
      princess_played(player_action)
    else
      "No Card Provided"
    end
  end

  def guard_played(player_action)
    player_return = {
      "Initiating Player Return" => "You guessed right!",
      "Target Player Return" => "You're out!"
    }
    initiating_player_name = player_action["Initiating Player"]
    target_player_name = player_action["Target Player"]
    guessed_card = player_action['Card Played Requirement']
    target_player_card = @players[target_player_name].hand[0]
    if guessed_card == target_player_card
      player_is_out(target_player_name)
      return player_return
    else
      player_return["Initiating Player Return"] = "You guessed wrong!"
      player_return["Target Player Return"] = "You're safe...for now"
      return player_return
    end
  end

  def priest_played(player_action)
    player_return = {
      "Initiating Player Return" => []
    }
    target_player = @players[player_action["Target Player"]]
    player_return["Initiating Player Return"] = target_player.hand
    return player_return
  end

  def baron_played(player_action)
    player_return = {
      "Initiating Player Return" => "You win the exchange!",
      "Target Player Return" => "You're out!"
    }
    initiating_player = @players[player_action["Initiating Player"]]
    ip_card_val = @@card_values[initiating_player.hand[0]]
    target_player = @players[player_action["Target Player"]]
    tp_card_val = @@card_values[target_player.hand[0]]
    if ip_card_val > tp_card_val
      player_is_out(target_player.name)
      return player_return
    elsif ip_card_val == tp_card_val
      player_return["Initiating Player Return"] = "It's a Tie!"
      player_return["Target Player Return"] = "It's a Tie!"
      return player_return
    else
      player_is_out(initiating_player.name)
      player_return["Initiating Player Return"] = "You're out!"
      player_return["Target Player Return"] = "You win the exchange!"
      return player_return
    end
  end

  def handmaid_played(player_action)
    player_name = player_action["Initiating Player"]
    player_obj = @players[player_name]
    player_obj.status = "Protected"
    return {
      "Initiating Player Return" => "You now have the handmaid's protection!"
    }
  end

  def prince_played(player_action)
    target_player = @players[player_action["Target Player"]]
    discarded = target_player.hand[0]
    @discarded.push(discarded)
    if discarded == "Princess"
      player_is_out(target_player.name)
      return {
        "Initiating Player Return" => "You got #{target_player.name} out!",
        "Target Player Return" => "You're out!",
        "All Player Return" => "#{target_player.name} discarded the Princess!"
      }
    else
      if @deck.empty?
        target_player.hand = [@removed_card]
      else
        target_player.discard(discarded)
        target_player.draw(self.get_card)
      end
      return {
        "Initiating Player Return" => "#{target_player.name} has discarded their hand",
        "Target Player Return" => "You must discard your hand"
      }
    end
  end

  def king_played(player_action)
    initiating_player = @players[player_action["Initiating Player"]]
    target_player = @players[player_action["Target Player"]]
    ip_hand = initiating_player.hand
    initiating_player.hand = target_player.hand
    target_player.hand = ip_hand
    player_return = {
      "Initiating Player Return" => initiating_player.hand,
      "Target Player Return" => target_player.hand
    }
    return player_return
  end

  def princess_played(player_action)
    player_name = player_action["Initiating Player"]
    player_is_out(player_name)
    player_return = {
      "Initiating Player Return" => "You played the princess, you're out!"
    }
    return player_return
  end

end
