require_relative "Player"
require "test/unit"

class TestPlayer < Test::Unit::TestCase

  def setup
    @player = Player.new("Player1")
  end

  def test_initalization()
    assert_equal("player1",@player.name.downcase)
    assert_equal([],@player.hand)
    assert_equal(nil,@player.game)
  end

  def test_draw()
    @player.draw("Guard")
    assert_equal("Guard",@player.hand[0])
    puts @player.hand
  end

  def test_discard()
    @player.draw("Guard")
    @player.draw("Princess")
    assert_equal("Guard", @player.discard("Guard"))
    assert_equal("Choose a card that's actually in your hand",@player.discard("Priest"))
    assert_equal("Princess",@player.discard("Princess"))
  end

  


end
