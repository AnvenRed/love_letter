require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require_relative 'LoveLetter.rb'
require_relative 'Player.rb'

game1 = LoveLetter.new
player1 = Player.new("Anirudh")
player2 = Player.new("Martin")
player3 = Player.new("Tamarcus")

game1.players.push(player1)
game1.players.push(player2)
game1.players.push(player3)

puts player1.name
puts player2.name

game1.shuffledDeck.pop

game1.players.each do |player|
  puts player.name
end

get '/' do
  game1.deck
end

get '/cardvalues' do
  json game1.cards
end

get '/players' do
  json game1.players.collect {|player| player.name}
end
