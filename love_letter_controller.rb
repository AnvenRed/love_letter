# myapp.rb
require 'sinatra'
require 'sinatra/contrib'
require 'uuid'

set :bind, '0.0.0.0'
set :port, 5000

arr = []
uuid = UUID.new
cards = [1, 2, 3, 4, 5, 6, 7, 8]
player_hands = {}
=begin
get '/' do
  arr << "#{request.ip}"
  allIPs = arr.map { |i| "'" + i.to_s + "'" }.join("<br>")
  "IPs<br>#{allIPs}"
end
=end
get '/' do
  if (cookies[:session] == nil) 
    thisKey = uuid.generate
    cookies[:session] = thisKey
  end
  "#{cookies[:session]}"
  redirect '/hand'
end

get '/hand' do
  if (cookies[:session] != nil)
    if (!player_hands.has_key?(cookies[:session]))
      size = 4
      hand = []
      while size > 0
        card = rand(8)
        hand << cards[card]
        size = size - 1
      end
      player_hands[cookies[:session]] = hand
    end
  end
    "#{player_hands[cookies[:session]]}"
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
  if (cookies[:session] != nil)
    if (player_hands.has_key?(cookies[:session]))
      hand = player_hands[cookies[:session]]
      hand.push(cards[rand(8)])
      player_hands[cookies[:session]] = hand
    end
  end
  redirect '/hand'
end

get '/peak' do
  display = "Player &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hands<br>"
  player_hands.each do |key, value|
    value = value.map { |i| "'" + i.to_s + "'" }.join(",")
    display += "#{key} #{value}<br>"
  end 
  "#{display}"
end
