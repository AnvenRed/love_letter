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

  def guard(guessee, guessed_card)
    if guessed_card == "Guard"
      "Guess a non-guard card"
    else
      guessee_card = @players[guessee].hand[0]
      if guessed_card == guessee_card
        "#{guessee} must discard"
      else
        "Wrong"
      end
    end
  end

end
