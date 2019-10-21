class Player

  attr_accessor :name, :hand, :game, :status

  def initialize(name)
    @name = name
    @hand = []
    @game = nil
    @status = "Open"
  end

  def draw(card_name)
    @hand.push(card_name)
  end

  def discard(card_name)
    if @hand.include? card_name
      @hand.delete_at(@hand.index(card_name))
    else
      raise 'You don\'t have this card in your hand'
    end
  end

  def play_guard(player_name,guessed_card)
    self.discard("Guard")
    {
      'Target Player' => player_name,
      'Card' => guessed_card
    }
  end

  def play_priest(player_name)
    self.discard("Priest")
    {
      'Target Player' => player_name
    }
  end

  def play_baron(target_player)
    self.discard("Baron")
    {
      "Initiating Player" => @name,
      "Target Player" => target_player
    }
  end

  def play_handmaid()
    self.discard("Handmaid")
    {
      'Initiating Player' => @name
    }
  end

  def play_prince(target_player)
    self.discard("Prince")
    {
      "Initiating Player" => @name,
      "Target Player" => target_player
    }
  end

  def play_king(target_player)
    self.discard("King")
    {
      "Initiating Player" => @name,
      "Target Player" => target_player
    }
  end

  def play_countess()
    self.discard("Countess")
  end

  def play_princess()
    self.discard("Princess")
    {
      "Initiating Player" => @name
    }
  end

end
