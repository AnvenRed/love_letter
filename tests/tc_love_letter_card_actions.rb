require_relative "../game_classes/LoveLetter"
require_relative "../game_classes/Player"
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

  def test_handmaid()
    @player1.draw("Handmaid")
    handmaid_action = @player1.play_handmaid
    assert_equal("Open", @player1.status)
    returned = @new_game.handmaid(handmaid_action)
    assert_equal("Player1 is now protected by the handmaid",returned)
    assert_equal("Protected", @player1.status)
  end

  def test_prince()
    @player1.draw("Prince")
    @player2.draw("Countess")
    top_card = @new_game.deck[-1]
    prince_action = @player1.play_prince("Player2")
    returned = @new_game.prince(prince_action)
    expected = {
      "Discarded" => "Countess"
    }
    assert_equal(expected,returned)
    assert_equal(top_card, @player2.hand[0])
  end

  def test_king()
    @player1.draw("King")
    @player1.draw("Priest")
    @player2.draw("Countess")
    king_action = @player1.play_king("Player2")
    @new_game.king(king_action)
    assert_equal(["Countess"], @player1.hand)
    assert_equal(["Priest"], @player2.hand)
  end

  def test_princess()
    @player1.draw("Princess")
    princess_action = @player1.play_princess
    assert_equal("Player1 is out!", @new_game.princess(princess_action))
    assert_equal("Closed", @player1.status)
  end


end
