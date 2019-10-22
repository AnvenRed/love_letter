class Player

  attr_accessor :name, :hand, :game, :status
  
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
      raise "You don't have this card in your hand"
    end
  end

  def play_guard(target_player,guessed_card)
    self.discard("Guard")
    player_action = create_action(target_player,"Guard")
    player_action["Card Played Requirement"] = guessed_card
    player_action
  end

  def play_priest(target_player)
    self.discard("Priest")
    player_action = create_action(target_player,"Priest")
    player_action
  end

  def play_baron(target_player)
    self.discard("Baron")
    player_action = create_action(target_player,"Baron")
    player_action
  end

  def play_handmaid()
    self.discard("Handmaid")
    player_action = create_action(@name,"Handmaid")
    player_action
  end

  def play_prince(target_player)
    self.discard("Prince")
    player_action = create_action(target_player,"Prince")
    player_action
  end

  def play_king(target_player)
    self.discard("King")
    player_action = create_action(target_player,"King")
    player_action
  end

  def play_countess()
    self.discard("Countess")
  end

  def play_princess()
    self.discard("Princess")
    player_action = create_action(@name,"Princess")
    player_action
  end

end
