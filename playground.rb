require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require_relative 'LoveLetter.rb'
require_relative 'Player.rb'

game1 = LoveLetter.new
player1 = Player.new("Anirudh", game1)
player2 = Player.new("Martin", game1)
player3 = Player.new("Tamarcus", game1)

game1.players[player1.name] = player1
game1.players[player2.name] = player2
game1.players[player3.name] = player3

puts player1.name
puts player2.name

game1.shuffledDeck.pop

game1.players.each do |player|
  puts player.name
end

get '/' do
  game1.shuffledDeck
end

get '/cardvalues' do
  json game1.cards
end

get '/players' do
  json game1.players.collect {|player| player.name}
end

get '/player1/draw' do
  player1.get_card(game1.draw)
end

get '/player2/draw' do
  player2.get_card(game1.draw)
end

get '/player3/draw' do
  player3.get_card(game1.draw)
end
