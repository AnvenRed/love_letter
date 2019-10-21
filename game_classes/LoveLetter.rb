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

  attr_accessor :deck, :players, :card_values, :removed_card

  def initialize()
    shuffled = @@unshuffledDeck.shuffle
    @removed_card = shuffled.pop
    @deck = shuffled
    @players = {}
    @card_values = @@card_values
  end

  def get_card()
    @deck.pop
  end

  def execute_card_action(card_name)
    if card_name == "Princess"
      "You lose"
    end
  end

  def guard(guard_action)
    guessee = guard_action['Target Player']
    guessed_card = guard_action['Card']
    if guessed_card == "Guard"
      "Guess a non-guard card"
    else
      guessee_card = @players[guessee].hand[0]
      if guessed_card == guessee_card
        "#{guessee} is out"
      else
        "Wrong"
      end
    end
  end

  def priest(priest_action)
    target_player = priest_action['Target Player']
    target_player = @players[target_player]
    target_player.hand
  end

  def baron(baron_action)
    initiating_player = @players[baron_action["Initiating Player"]]
    ip_card_val = @@card_values[initiating_player.hand[0]]
    target_player = @players[baron_action["Target Player"]]
    tp_card_val = @@card_values[target_player.hand[0]]
    if ip_card_val > tp_card_val
      "#{target_player.name} is out!"
    elsif ip_card_val == tp_card_val
      "Tie"
    else
      "#{initiating_player.name} is out!"
    end
  end

  def handmaid(handmaid_action)
    initiating_player = handmaid_action["Initiating Player"]
    @players[initiating_player].status = "Protected"
    "#{initiating_player} is now protected by the handmaid"
  end

  def prince(prince_action)
    target_player = @players[prince_action["Target Player"]]
    discarded = target_player.hand[0]
    if @deck.empty?
      target_player.hand = [@removed_card]
    else
      target_player.discard(discarded)
      target_player.draw(self.get_card)
    end
    {
      "Discarded" => discarded
    }
  end

  def king(king_action)
    initiating_player = @players[king_action["Initiating Player"]]
    target_player = @players[king_action["Target Player"]]
    ip_hand = initiating_player.hand
    initiating_player.hand = target_player.hand
    target_player.hand = ip_hand
  end

  def princess(princess_action)
    initiating_player = @players[princess_action["Initiating Player"]]
    initiating_player.status = "Closed"
    "#{initiating_player.name} is out!"
  end

end