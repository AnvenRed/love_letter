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
    guard_action = {
      'Target Player' =>  "",
      'Card' => ""
    }
    guard_action['Target Player'] = "Player1"
    guard_action['Card'] = "Princess"
    assert_equal("Player1 is out",@new_game.guard(guard_action))
    guard_action['Target Player'] = "Player1"
    guard_action['Card'] = "King"
    assert_equal("Wrong", @new_game.guard(guard_action))
    guard_action['Target Player'] = "Player1"
    guard_action['Card'] = "Guard"
    assert_equal("Guess a non-guard card", @new_game.guard(guard_action))
  end

  def test_priest()
    @player2.draw("Princess")
    priest_action = {
      'Target Player' => 'Player2'
    }
    expected = ["Princess"]
    returned = @new_game.priest(priest_action)
    assert_equal(expected,returned)
  end

  def test_baron()
    @player1.draw("Baron")
    @player1.draw("King")
    @player2.draw("Priest")
    baron_action = @player1.play_baron("Player2")
    expected = "Player2 is out!"
    assert_equal(expected,@new_game.baron(baron_action))
    @player2.discard("Priest")
    @player2.draw("Countess")
    expected = "Player1 is out!"
    assert_equal(expected,@new_game.baron(baron_action))
  end


end
