# myapp.rb
require 'sinatra'
require 'sinatra/contrib'
require 'uuid'

set :bind, '0.0.0.0'
set :port, 5000

love_letter = LoveLetter.new
arr = []
uuid = UUID.new
player1 = Player.new('Player1')
player2 = Player.new('Player2')
love_letter.players['Player1'] = player1
love_letter.players['Player2'] = player2

deck = love_letter.deck

get '/' do
  if (cookies[:session] == nil) 
    thisKey = uuid.generate
    cookies[:session] = thisKey
  end
  "#{cookies[:session]}"
  redirect '/draw'
end

=begin
get '/hand' do
  if (cookies[:session] != nil)
    if (!player_hands.has_key?(cookies[:session]))
      size = 4
      hand = []
      while size > 0
        card = rand(8)
        hand << deck[card]
        size = size - 1
      end
      player_hands[cookies[:session]] = hand
    end
  end
    "#{player_hands[cookies[:session]]}"
end
=end

get '/deck' do
  "#{love_letter.deck}"
end

get '/hand' do
  "#{player1.hand}"
end

get '/remove_card' do
  if (cookies[:session] != nil)
    if (player_hands.has_key?(cookies[:session]))
      hand = player_hands[cookies[:session]]
      hand.pop
      player_hands[cookies[:session]] = hand
    end
  end
  redirect '/hand'
end

get '/draw' do
  player1.draw(love_letter.get_card)
  redirect '/hand'
end

=begin
get '/draw' do
  if (cookies[:session] != nil)
    if (player_hands.has_key?(cookies[:session]))
      hand = player_hands[cookies[:session]]
      hand.push(cards[rand(8)])
      player_hands[cookies[:session]] = hand
    end
  end
  redirect '/hand'
end
=end

get '/peak' do
  display = "Player &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hands<br>"
  player_hands.each do |key, value|
    value = value.map { |i| "'" + i.to_s + "'" }.join(",")
    display += "#{key} #{value}<br>"
  end 
  "#{display}"
end
