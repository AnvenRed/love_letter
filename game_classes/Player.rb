class Player

  attr_accessor :name, :hand, :in_game, :status, :is_turn

  def create_action(target,card_played,card_played_requirement=nil)
    {
      "Initiating Player" => @name,
      "Target Player" => target,
      "Card Played" => card_played,
      "Card Played Requirement" => card_played_requirement
    }
  end

  def initialize(name)
    @name = name
    @hand = []
    @in_game = true
    @status = "Open"
    @is_turn = false
  end

  def draw(card_name)
    @hand.push(card_name)
  end

  def discard(card_name)
    if @hand.include? card_name
      @hand.delete_at(@hand.index(card_name))
    else
      raise "You don't have this card in your hand"
    end
  end

end
