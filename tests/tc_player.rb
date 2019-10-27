require_relative "../game_classes/Player"
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
    assert_equal(["Guard"],@player.draw("Guard"))
    assert_equal(["Guard","Countess"], @player.draw("Countess"))
  end

  def test_discard()
    @player.draw("Guard")
    assert_equal("Guard", @player.discard("Guard"))
    assert_raise RuntimeError do
      @player.discard("Priest")
    end
  end

end
