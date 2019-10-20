class LoveLetter

  @@cards = {
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

  attr_accessor :shuffledDeck, :players, :cards


  def initialize()
    @shuffledDeck = @@unshuffledDeck.shuffle
    @players = []
    @cards = @@cards
  end

  def deck()
    @shuffledDeck
  end

  def cards()
    @cards
  end

end
