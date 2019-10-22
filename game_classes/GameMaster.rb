module PlayGame
  def add_player(game,player)
    game.add_player(player)
  end
end


class GameMaster
  include PlayGame
end
