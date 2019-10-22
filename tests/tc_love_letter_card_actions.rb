require_relative "../game_classes/LoveLetter"
require_relative "../game_classes/Player"
require "test/unit"

class TestLoveLetterCardActions < Test::Unit::TestCase

  def setup
    @new_game = LoveLetter.new
    @player1 = Player.new("Player1")
    @player2 = Player.new("Player2")
    @new_game.add_player(@player1)
    @new_game.add_player(@player2)
  end

  def test_change_status()
    assert_equal(2, @new_game.in_play.length)
    assert_equal("Open", @player1.status)
    status_change = @new_game.create_status_change("Player1","Protected")
    @new_game.change_status(status_change)
    expected = "Protected"
    returned = @player1.status
    assert_equal(expected, returned)
    status_change = @new_game.create_status_change("Player2","Out")
    @new_game.change_status(status_change)
    expected = ["Player1"]
    returned = @new_game.in_play
    assert_equal(expected, returned)
    expected = "Out"
    returned = @player2.status
    assert_equal(expected, returned)
  end

  def test_guard_played_guess_right()
    @player1.draw("Guard")
    @player2.draw("Countess")
    player_action = @player1.play_guard("Player2","Countess")
    expected = {
      "Player" => "Player2",
      "Status" => "Out"
    }
    returned = @new_game.guard_played(player_action)
    assert_equal(expected, returned)
  end

  def test_guard_played_guess_wrong()
    @player1.draw("Guard")
    @player2.draw("Countess")
    player_action = @player1.play_guard("Player2","Baron")
    expected = "Wrong"
    returned = @new_game.guard_played(player_action)
    assert_equal(expected, returned)
  end

  def test_priest_played()
    @player1.draw("Priest")
    @player2.draw("Countess")
    player_action = @player1.play_priest("Player2")
    expected = ["Countess"]
    returned = @new_game.priest_played(player_action)
    assert_equal(expected, returned)
  end

  def test_baron_played_win()
    @player1.draw("Baron")
    @player1.draw("King")
    @player2.draw("Priest")
    player_action = @player1.play_baron("Player2")
    expected = {
      "Player" => "Player2",
      "Status" => "Out"
    }
    returned = @new_game.baron_played(player_action)
    assert_equal(expected, returned)
  end

  def test_baron_played_lose()
    @player1.draw("Baron")
    @player1.draw("King")
    @player2.draw("Countess")
    player_action = @player1.play_baron("Player2")
    expected = {
      "Player" => "Player1",
      "Status" => "Out"
    }
    returned = @new_game.baron_played(player_action)
    assert_equal(expected, returned)
  end

  def test_baron_draw()
    @player1.draw("Baron")
    @player1.draw("Prince")
    @player2.draw("Prince")
    player_action = @player1.play_baron("Player2")
    expected = "Tie"
    returned = @new_game.baron_played(player_action)
    assert_equal(expected, returned)
  end

  def test_handmaid_played()
    @player1.draw("Handmaid")
    player_action = @player1.play_handmaid
    expected = {
      "Player" => "Player1",
      "Status" => "Protected"
    }
    returned = @new_game.handmaid_played(player_action)
    assert_equal(expected, returned)
  end

  def test_prince_played()
    @player1.draw("Prince")
    @player2.draw("Countess")
    top_card = @new_game.deck[-1]
    player_action = @player1.play_prince("Player2")
    returned = @new_game.prince_played(player_action)
    expected = {
      "Discarded" => "Countess"
    }
    assert_equal(expected,returned)
    assert_equal(top_card, @player2.hand[0])
  end

  def test_prince_played_empty_deck()
    @player1.draw("Prince")
    @player2.draw("Countess")
    @new_game.deck = []
    player_action = @player1.play_prince("Player2")
    @new_game.prince_played(player_action)
    expected = @new_game.removed_card
    actual = @player2.hand[0]
    assert_equal(expected, actual)
  end

  def test_king_played()
    @player1.draw("King")
    @player1.draw("Priest")
    @player2.draw("Countess")
    player_action = @player1.play_king("Player2")
    @new_game.king_played(player_action)
    assert_equal(["Countess"], @player1.hand)
    assert_equal(["Priest"], @player2.hand)
  end

  def test_princess_played()
    @player1.draw("Princess")
    player_action = @player1.play_princess
    expected = {
      "Player" => "Player1",
      "Status" => "Out"
    }
    returned = @new_game.princess_played(player_action)
    assert_equal(expected, returned)
  end


end
