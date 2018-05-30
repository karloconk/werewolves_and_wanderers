# Final Project: Werewolves and Wanderer
# Date: 02-May-2018
# Authors:
#          A01374526 José Karlo Hurtado Corona
#          A01373890 Gabriela Aguilar Lugo

require 'yaml'
require 'sinatra'
require 'json'

$light         = 0
$suit          = 0
$wealth        = 0
$sword         = 0
$amulet        = 0
$axe           = 0
$food          = 0
$food2         = 0
$globaljson    = 0

PORT = 8082
URL = "http://localhost:#{ PORT }/"

store = YAML.load_file('store.yml')

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

#method for getting the data we need
get '/store/:id/:light/:suit/:wealth/:sword/:amulet/:axe/:food/:food2' do
  supertext = ""
  id_str = params['id']
  $id = convert_to_int(id_str)
  light_str = params['light']
  $light = convert_to_int(light_str)
  suit_str = params['suit']
  $suit = convert_to_int(suit_str)
  wealth_str = params['wealth']
  $wealth = convert_to_int(wealth_str)
  sword_str = params['sword']
  $sword = convert_to_int(sword_str)
  amulet_str = params['amulet']
  $amulet = convert_to_int(amulet_str)
  axe_str = params['axe']
  $axe = convert_to_int(axe_str)
  food_str = params['food']
  $food = convert_to_int(food_str)
  food_str2 = params['food2']
  $food2 = convert_to_int(food_str2)

  if 0 <= $id and $id < store.size
    $globaljson = JSON.pretty_generate(store[$id])
  else
    [404, {'error' => "store not found with id = #{ id_str }"}.to_json]
  end
  $globaljson = JSON.parse($globaljson)
  
  broker_wrapper = broker
  if broker_wrapper != nil
    supertext += broker_wrapper
  end
  supertext += "\n#{poorman}"
  turn_to_json(supertext)
end

#method for turning all the data into JSON 
def turn_to_json(someString)
  json_ret = {
    'text'   => someString,
    'id'     => $id,  
    'light'  => $light,  
    'suit'   => $suit,   
    'wealth' => $wealth, 
    'sword'  => $sword,  
    'amulet' => $amulet, 
    'axe'    => $axe,    
    'food'   => $food,   
    'food2'  => $food2   
  }
  JSON[json_ret]
end

#method for determining if uer is poor (in the game)
def poorman
  poortext = ""

    if $wealth <= 0
      poortext = "YOU HAVE NO MONEY\n"
      $id = 0
    else
      poortext = "YOU HAVE $ #{$wealth}\n"                
    end

  return poortext
end

#Method for determining if user can buy something and if so, what does it buy.
def broker

  if($id != 0 )
    if(too_much_stuff == nil)
      if (liar_liar($id,$food2) != 0 ) 
        return $globaljson['liartext']
      else
        if ($id == 7)
          foodtext = $globaljson['extratext'] 
          foodtext += "#{$food2}"
          foodtext += $globaljson['boughttext'] 
          return foodtext
        else
          return $globaljson['boughttext']  
        end      
      end
    else
      return too_much_stuff
    end
  else
    return " "
  end
end

#Method for determining if user is eligible to buy something
def too_much_stuff
  case $id
    when 1
        if $light == 1
          $globaljson['extratext']
        end
    when 2
        if $axe == 1
          $globaljson['extratext']
        end
    when 3
        if $sword == 1
          $globaljson['extratext']
        end
    when 4
        $globaljson['extratext']
    when 5
        if $amulet == 1
          $globaljson['extratext']
        end
    when 6
        if $suit == 1
          $globaljson['extratext']
        end
    when 7
        nil
    else
        ""                
  end
end

#Method for determining if the player has less money than it says, therefore becoming a liar.
def liar_liar(nummer,foods)
  case nummer
      when 1
        $wealth -= 15
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $light += 1
              return 0
          end
      when 2
        $wealth -= 10
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $axe += 1
              return 0
          end
      when 3
        $wealth -= 20
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $sword += 1
              return 0
          end
      when 4
        $wealth -= 2 * foods
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              return 0
          end
      when 5
        $wealth -= 30
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $amulet += 1
              return 0
          end
      when 6
        $wealth -= 50
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $suit +=1
              return 0
          end
      when 7
        $wealth -= 2 * foods
          if $wealth < 0
              cheater_cheetah
              return 1
          else
              $food += foods
              return 0
          end
      else
          return 0
  end
end

#Method for punishing the cheater by taking his stuff away
def cheater_cheetah
  $light      = 0
  $suit       = 0
  $wealth     = 0
  $sword      = 0
  $amulet     = 0
  $axe        = 0
  $food       /= 4
  $food = $food.to_i
end