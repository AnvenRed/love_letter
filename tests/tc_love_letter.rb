require_relative "../game_classes/LoveLetter"
require_relative "../game_classes/Player"
require "test/unit"

class TestLoveLetter < Test::Unit::TestCase

  def setup
    @new_game = LoveLetter.new
  end

  def test_initalization
    player1 = Player.new("Player1")
    @new_game.add_player(player1)
    expected = ["Player1"]
    actual = @new_game.in_play
    assert_equal(expected, actual)
    expected = player1
    actual = @new_game.players["Player1"]
    assert_equal(expected, actual)
  end

  def test_get_card
    assert_equal(@new_game.deck[-1], @new_game.get_card)
  end

  def test_card_value_lookup
    assert_equal(1, @new_game.card_values["Guard"])
  end

  def test_deck_initalized
    assert(@new_game.card_values.key?(@new_game.removed_card))
    assert_equal(16, @new_game.deck.length)
  end

end
