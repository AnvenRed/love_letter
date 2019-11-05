# myapp.rb
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/json'
require 'sinatra/cross_origin'
require 'uuid'
require_relative './game_classes/LoveLetter.rb'
require_relative './game_classes/Player.rb'
require_relative './game_classes/GameMaster.rb'

set :bind, '0.0.0.0'
set :port, 5000
configure do
  enable :cross_origin
end
before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

arr = []
uuid = UUID.new
game = LoveLetter.new
gm = GameMaster.new(game)
players = {}
player_map = {}
player_names = {}
count = 0

get '/' do
  if (cookies[:session] == nil) 
    thisKey = uuid.generate
    cookies[:session] = thisKey
    player = Player.new(thisKey)
    players[thisKey] = player
    return json cookies[:session]
  end
  #if (players.keys.length == 3)
  #  redirect '/game_start'
  #end
end

post '/set_name' do
  request.body.rewind
  request_body = JSON.parse request.body.read
  player_name = request_body['name']
  player_names[player_name] = cookies[:session]
  return "Name set to: #{player_name}"
end

get '/game_start' do
  players.each_value do |player|
    #puts "#{player.name}"
    gm.add_player(player)
  end
  json gm.start_game
  redirect '/hand'
end

post '/player_action' do
  request.body.rewind
  player_action = JSON.parse request.body.read
  player_action["Initiating Player"] = player_names[player_action["Initiating Player"]] 
  player_action["Target Player"] = player_names[player_action["Target Player"]]
  puts player_action
  json gm.player_plays_card(player_action)
end

get '/state' do
  json gm.get_current_state
end

get '/hand' do
  player = players[cookies[:session]]
  "#{player.hand}"
end

get '/draw' do
  player = players[cookies[:session]]
  gm.player_draws_card(player) 
  redirect '/hand'
end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
