require_relative "LoveLetter"
require_relative "Player"
require "test/unit"

class TestLoveLetterCardActions < Test::Unit::TestCase

  def setup
    @new_game = LoveLetter.new
    @player1 = Player.new("Player1")
    @player2 = Player.new("Player2")
    @new_game.players["Player1"] = @player1
    @new_game.players["Player2"] = @player2
  end

  def test_guard()
    @player1.hand = ["Princess"]
    assert_equal("Player1 is out",@new_game.guard("Player1","Princess"))
    assert_equal("Wrong", @new_game.guard("Player1","King"))
    assert_equal("Guess a non-guard card", @new_game.guard("Player1","Guard"))
  end


end
