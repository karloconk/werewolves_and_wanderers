# Final Project: Werewolves and Wanderer
# Date: 02-May-2018
# Authors:
#          A01374526 José Karlo Hurtado Corona
#          A01373890 Gabriela Aguilar Lugo

require 'yaml'
require 'sinatra'
require 'json'

PORT = 8081
URL = "http://localhost:#{ PORT }/"

rooms = YAML.load_file('rooms.yml')

#method for configuring web stuff
configure do
  set :bind, '0.0.0.0'
  set :port, PORT
end

#method for configuring JSON stuff
before do
  content_type :json
end

#method for configuring error stuff
not_found do
  {'error' => "Resource not found: #{ request.path_info }"}.to_json
end

#method for configuring ints
def convert_to_int(str)
  begin
    Integer(str)
  rescue ArgumentError
    -1
  end
end

#method for printing all ints
get '/rooms' do
  JSON.pretty_generate(rooms.map.with_index do |q, i|
    {
      'id' => i,
      'room' => q['room']  }
  end)
end

#method for the room we need
get '/rooms/:id' do
  id_str = params['id']
  id = convert_to_int(id_str)
  if 0 <= id and id < rooms.size
    JSON.pretty_generate(rooms[id])
  else
    [404, {'error' => "room not found with id = #{ id_str }"}.to_json]
  end
end
