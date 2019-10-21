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
      card_name
    else
      "Choose a card that's actually in your hand"
    end
  end

  def guard()
    
  end

end
