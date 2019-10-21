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
    assert_equal("Guard", @player.discard("Guard"))
    assert_raise RuntimeError do
      @player.discard("Priest")
    end
  end

  def test_play_guard()
    @player.draw("Guard")
    expected = {
      'Target Player' => "Player2",
      'Card' => "Princess"
    }
    returned = @player.play_guard("Player2","Princess")
    assert_equal("Player2",returned['Target Player'])
    assert_equal("Princess",returned['Card'])
  end

  def test_play_priest()
    @player.draw("Priest")
    expected = "Player2"
    returned = @player.play_priest("Player2")['Target Player']
    assert_equal(expected,returned)
  end

  def test_play_baron()
    @player.draw("Baron")
    expected = {
      'Initiating Player' => @player.name,
      'Target Player' => "Player2"
    }
    assert_equal(expected,@player.play_baron("Player2"))
  end


end
