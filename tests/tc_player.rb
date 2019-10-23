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

  def test_play_guard()
    @player.draw("Guard")
    expected = @player.create_action("Player2","Guard","Princess")
    returned = @player.play_guard("Player2","Princess")
    assert_equal(expected,returned)
  end

  def test_play_priest()
    @player.draw("Priest")
    expected = @player.create_action("Player2","Priest")
    returned = @player.play_priest("Player2")
    assert_equal(expected,returned)
  end

  def test_play_baron()
    @player.draw("Baron")
    expected = @player.create_action("Player2","Baron")
    returned = @player.play_baron("Player2")
    assert_equal(expected,returned)
  end

  def test_play_handmaid()
    @player.draw("Handmaid")
    expected = @player.create_action("Player1","Handmaid")
    returned = @player.play_handmaid
    assert_equal(expected,returned)
  end

  def test_play_prince()
    @player.draw("Prince")
    expected = @player.create_action("Player2","Prince")
    returned = @player.play_prince("Player2")
    assert_equal(expected, returned)
  end

  def test_play_king()
    @player.draw("King")
    expected = @player.create_action("Player2","King")
    returned = @player.play_king("Player2")
    assert_equal(expected,returned)
  end

  def test_play_countess()
    @player.draw("Priest")
    @player.draw("Countess")
    @player.play_countess
    assert_equal(["Priest"],@player.hand)
  end

  def test_play_princess()
    @player.draw("Princess")
    expected = @player.create_action("Player1","Princess")
    returned = @player.play_princess
    assert_equal(expected, returned)
  end

end
