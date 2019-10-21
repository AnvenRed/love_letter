require_relative "LoveLetter"
require "test/unit"

class TestLoveLetter < Test::Unit::TestCase

  def setup
    @new_game = LoveLetter.new
  end

  def test_discard
    assert_equal(@new_game.deck[-1],@new_game.get_card)
  end

  def test_card_value_lookup
    assert_equal(1, @new_game.card_values["Guard"])
  end

  def test_deck_initalized
    puts "Removed Card: #{@new_game.removed_card}"
    assert_equal(16, @new_game.deck.length)
  end

  def test_execute_card_action
    assert_equal("you lose",@new_game.execute_card_action("Princess").downcase)
  end



end
