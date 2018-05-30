# Final Project: Werewolves and Wanderer
# Date: 02-May-2018
# Authors:
#          A01374526 José Karlo Hurtado Corona
#          A01373890 Gabriela Aguilar Lugo

# File: w_&_w.rb

require 'net/http'
require 'json'

#Global variables area
$roomnumber    = 6
$light         = 0
$wealth        = 30
$strength      = 60
$food          = 0
$tally         = 0
$monkills      = 0
$name          = 0
$sword         = 0
$amulet        = 0
$axe           = 0
$suit          = 0
$danger_level  = 0
$current_mon   = ""

#Method to put the whole game together. (PROTIP: To actually play the game just uncomment the last line of code in this file and run this file)
def game
    setup_castle
    setup_stats
    print "WHAT IS YOUR NAME, EXPLORER? "
    $name = gets.strip
    status("GREETING")
    activity = ""
    monster_at_room = 0
    while $roomnumber != 0 and $roomnumber != 11 and $strength>0
        if  (get_room_stuff(6)<0)
            monster_at_room = 1
        else
            monster_at_room = 0
        end

        if $roomnumber == 9
            room_9
        else
            if activity == "ROOM" or activity == "I"
                status(activity)
            else
                status("")
            end

            print("WHAT DO YOU WANT TO DO? ")
            if monster_at_room != 0
                f_or_fl = errorHandler(gets.strip.to_s)
                if f_or_fl == "F" or f_or_fl == "R"
                    activity = send(f_or_fl.to_sym)   
                else
                    puts("YOU MUST FIGHT OR RUN, NOTHING ELSE")
                end
            else
                activity = send(errorHandler(gets.strip.to_s).to_sym)                
            end
            puts("\n")
            asterSick
            puts("\n")
        end
    end
    if $strength<=0
        puts "YOU HAVE DIED........."
        score_method
    end

    if $roomnumber == 11
        puts ("YOU'VE DONE IT!!")
        sleep(1)
        puts("\nTHAT WAS THE EXIT FROM THE CASTLE")
        sleep(1)
        puts("\nYOU HAVE SUCCEEDED,#{$name}!")
        sleep(1)
        puts("\nYOU MANAGED TO GET OUT OF THE CASTLE")
        sleep(1)
        puts("\nWELL DONE!\n")
        sleep(1)        
        score_method
    end
end

#method for getting the value of current room attribute
def get_room_stuff(pos)
    my_port             =  8083
    room_map_message       =  "/maps/#{$roomnumber}/#{pos}"
    url = URI.parse("http://localhost:#{my_port}#{room_map_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }
    my_json = JSON.parse(res.body) 
    if my_json["east"]
        return my_json["east"]
    
    elsif my_json["west"]
        return my_json["west"]

    elsif my_json["north"]
        return my_json["north"]

    elsif my_json["contents"]
        return my_json["contents"]

    elsif my_json["south"]
        return my_json["south"]

    elsif my_json["down"]
        return my_json["down"]

    elsif my_json["up"]
        return my_json["up"]    
    end
end

#method for getting the value of some room attribute
def get_some_room_stuff(roomnumberone,pos)
    my_port             =  8083
    room_map_message       =  "/maps/#{roomnumberone}/#{pos}"
    url = URI.parse("http://localhost:#{my_port}#{room_map_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }
    my_json = JSON.parse(res.body) 
    if my_json["east"]
        return my_json["east"]
    
    elsif my_json["west"]
        return my_json["west"]

    elsif my_json["north"]
        return my_json["north"]

    elsif my_json["contents"]
        return my_json["contents"]

    elsif my_json["south"]
        return my_json["south"]

    elsif my_json["down"]
        return my_json["down"]

    elsif my_json["up"]
        return my_json["up"]    
    end
end

#method for setting a value at a room
def set_at_room(roomneu,pos, newone)
    my_port             =  8083
    room_map_message       =  "/setmaps/#{roomneu}/#{pos}/#{newone}"
    url = URI.parse("http://localhost:#{my_port}#{room_map_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }
    my_json = JSON.parse(res.body) 
    if my_json["ok"] != "everything is cool and good"
        raise"rooms not updated"
    end
end

#Method for introducing the required format to the game using asterisks.
def asterSick
    puts("\n****************************\n")
    return "\n****************************\n"
end

#Method for handling incorrect user inputs without disturbing the continuity of the game. 
def errorHandler(letter)
    if letter == "N" or letter == "S" or letter ==  "E" or letter == "W" or letter == "U" or letter == "D" or letter == "I" or letter == "Q" or letter == "C" or letter == "L" or letter == "P" or letter == "F" or letter == "R" or letter == "M" or letter == "H" or letter == "T" 
        return letter
    else
        puts("\n\nI DONT KNOW WHAT YOU ARE TELLING ME TO DO:\n")
        return "H"
    end
end

#Method for setting up the Terrors and Treasures in the castle
def setup_castle
    randomnums = Random.new
    zero_out
    treasures_allot
    terrors_allot
    set_at_room(4,6, 100 + randomnums.rand(1...100))
    set_at_room(16,6, 100 + randomnums.rand(1...100))
end

#method for setting up the castle prior to setting up the castle
def zero_out
    my_port             =  8083
    room_map_message       =  "/zeroout"
    url = URI.parse("http://localhost:#{my_port}#{room_map_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }

    my_json = JSON.parse(res.body) 
    if my_json["ok"] != "everything is cool and good"
        raise"rooms not updated"
    end
end

#Method for setting up random wealth and strength
def setup_stats
    randomnums = Random.new
    $strength += randomnums.rand(1...100)
    $wealth   += randomnums.rand(1...100)
end

#Method for setting up the Treasures in the castle
def treasures_allot
    randomnums = Random.new
    for num in (1..4) do
        roomn = randomnums.rand(1...19)
        num += 1
        while roomn == 6 or roomn == 11  or roomn == 9 or get_some_room_stuff(roomn,6) != 0
            roomn = randomnums.rand(1...19)
        end
        num-=1
        set_at_room(roomn,6,  randomnums.rand(10...109))
        #puts $ooms_map[roomn]
        #puts("----------------treasure")
    end
end

#Method for setting up the Terrors in the castle
def terrors_allot
    randomnums = Random.new
    for num in (1..6) do
        roomn = randomnums.rand(1...19)
        num += 1
        while roomn == 6 or roomn == 11 or roomn == 9 or get_some_room_stuff(roomn,6) != 0
            roomn = randomnums.rand(1...19)
        end
        num-=1
        set_at_room(roomn,6,num)
        #puts $ooms_map[roomn]
        #puts("----------------terror")
    end
end

#Method for the current status of the game A.K.A.: GUI
def status(act)
    extratext = ""
    moneytext = "YOU HAVE NO MONEY\n"
    perkstext = ""
    help_text = ""

    if $strength <10
        extratext <<  "WARNING, #{$name} , YOUR STRENGTH IS RUNNING LOW\n"
    end 
    if $wealth >= 1
    moneytext =  "YOU HAVE $ #{$wealth}.\n"
    end
    if $food >= 1
        extratext << "YOUR PROVISIONS SACK HOLDS #{$food} UNITS OF FOOD\n"
    end 

    if $suit >= 1
        perkstext <<  "YOU ARE WEARING ARMOR.\n"
    end

    if ($sword !=0 or $amulet !=0 or $axe !=0)
        perkstext <<  "YOU ARE CARRYING "
        if $sword >= 1
            perkstext <<  "A SWORD "
        end
        if $amulet >= 1
            if $sword != 0 and $axe != 0
                perkstext << ", "
            elsif $sword != 0 and axe == 0
                perkstext << "AND "
            end
            perkstext <<  "AN AMULET"
        end

        if $axe >= 1
            if $sword != 0 or $amulet != 0
                perkstext << " AND "
            end
            perkstext <<  "AN AXE"
        end
        perkstext << "\n"
    end

    if act == "ROOM" or act == "GREETING" or act == "I"
        if $light == 0 and $roomnumber != 6
            extratext << "IT IS TOO DARK TO SEE ANYTHING\n"
        else
            extratext <<  "#{room_descriptions_method} \n"            
        end
    end

    if act == "GREETING"
        help_text = "(YOU CAN PRESS H AT ANY MOMENT TO GET SOME HELP)"
    end

    roomcontents = room_contents

    puts("#{$name}, YOUR STRENGTH IS #{$strength}.\n#{moneytext}#{perkstext}\n#{asterSick}\n#{extratext}#{roomcontents}#{help_text}\n")                
end

#method for storing and constructing the room descriptions using rooms microservice
def room_descriptions_method
    my_port             =  8081
    htttproomnumber     =  $roomnumber
    roomsNtext          =  "/#{htttproomnumber}"
    rooms_message       =  "/rooms#{roomsNtext}"
    url = URI.parse("http://localhost:#{my_port}#{rooms_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
        http.request(req)
    }
    my_json = JSON.parse(res.body) 
    return my_json["room"].to_s
end

#Method for displaying the contents of the room
def room_contents

    if get_room_stuff(6) < 9  && get_room_stuff(6) > 0
        sleep(1)        
        monstertext = "DANGER...THERE IS A MONSTER HERE....\nIT'S A "
        
        sleep(1)        
        case  get_room_stuff(6)   
            when 1
                monstertext += "FEROCIOUS WEREWOLF"
                $current_mon = "FEROCIOUS WEREWOLF"
                $danger_level = 5
            when 2
                monstertext += "FANATICAL FLESHGORGER"
                $current_mon = "FANATICAL FLESHGORGER"
                $danger_level = 10
            when 3
                monstertext += "MALOVENTY MALDEMER"
                $current_mon = "MALOVENTY MALDEMER"
                $danger_level = 15
            when 4 
                monstertext += "DEVASTATING ICE-DRAGON"
                $current_mon = "DEVASTATING ICE-DRAGON"
                $danger_level = 20
            when 5
                monstertext += "HORRENDOUS HODGEPODGER"
                $current_mon = "HORRENDOUS HODGEPODGER"
                $danger_level = 25
            when 6
                monstertext += "GHASTLY GRUESOMENESS"
                $current_mon = "GHASTLY GRUESOMENESS"
                $danger_level = 30
        end
        monstertext += ".\nTHE DANGER LEVEL IS #{$danger_level}!!\n\n"
        return monstertext
    elsif get_room_stuff(6) > 9
        randomnums = Random.new 
        sleep(1)
        f_rand = randomnums.rand(1..2)   
        if f_rand==1
            return  "THERE IS TREASURE HERE WORTH $#{get_room_stuff(6)}"            
        else
            return  "THERE ARE GEMS  HERE WORTH $#{get_room_stuff(6)}"            
        end
    end
end

#Method for Letter I(Opening Inventory and store) 
def I
    asterSick
    item_required = 42
    bought_food = "I"
    puts("PROVISIONS  & INVENTORY\n\nYOU HAVE $ #{$wealth}\n\nYOU CAN BUY 1 - FLAMING TORCH ($15)
            2 - AXE ($10)
            3 - SWORD ($20)
            4 - FOOD ($2 PER UNIT)
            5 - MAGIC AMULET ($30)
            6 - SUIT OF ARMOR ($50)
            0 - TO CONTINUE ADVENTURE")
    if $light == 1
        puts("YOU HAVE A TORCH\n")
    end
    if $axe == 1
        puts("YOUR SUPPLIES NOW INCLUDE ONE AXE\n")
    end
    if $sword == 1
        puts("YOU SHOULD GUARD YOUR SWORD WELL\n")
    end
    if $amulet == 1
        puts("YOUR AMULET WILL AID YOU IN TIMES OF STRESS\n")
    end
    if $suit == 1
        puts("YOU LOOK GOOD IN ARMOR\n")
    end

    while (item_required!=0)
        puts("\n------------------------------------\n\n")
        if item_required != 0
            print "ENTER NO. OF ITEM REQUIRED?  "
            item_required = gets.strip.to_i
            puts("\n")
            if item_required != 0
                microservice_i(item_required)
            end
        end
    end
    return bought_food
end

#Method to actually call a microservice for I
def microservice_i(id)
    my_port       =  8082
    store_message =  "/store/#{id}/#{$light}/#{$suit}/#{$wealth}/#{$sword}/#{$amulet}/#{$axe}/#{$food}/#{0}"
    url = URI.parse("http://localhost:#{my_port}#{store_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }
    my_json = JSON.parse(res.body) 

    $light   = my_json['light']
    $suit    = my_json['suit']
    $wealth  = my_json['wealth']
    $sword   = my_json['sword']
    $amulet  = my_json['amulet']
    $axe     = my_json['axe']
    $food    = my_json['food']
    puts("#{my_json['text']}\n")

    if id == 4
        food_units = gets.strip.to_i
        buy_food(7,food_units)
    end
end

#SideMethod for when buying food
def buy_food(id,food_units)
    my_port       =  8082
    store_message =  "/store/#{id}/#{$light}/#{$suit}/#{$wealth}/#{$sword}/#{$amulet}/#{$axe}/#{$food}/#{food_units}"
    url = URI.parse("http://localhost:#{my_port}#{store_message}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port){|http|
    http.request(req)
    }
    my_json = JSON.parse(res.body) 

    $light   = my_json['light']
    $suit    = my_json['suit']
    $wealth  = my_json['wealth']
    $sword   = my_json['sword']
    $amulet  = my_json['amulet']
    $axe     = my_json['axe']
    $food    = my_json['food']
    puts("#{my_json['text']}\n")
end

#Method for Letter P(Pick up treasure) 
def P
    if(get_room_stuff(6) > 0)
        if $light == 0
            puts("YOU CANNOT SEE WHERE IT IS")
        else
            $wealth += get_room_stuff(6)
            puts("PICKED UP $#{get_room_stuff(6)}!")
            set_at_room($roomnumber,6, 0)
        end
    else
        puts("THERE IS NO TREASURE TO PICK UP")
    end
end

#Method for Letter F(Fight)
def F
    if get_room_stuff(6) >= 9
        puts("THERE IS NOTHING TO FIGHT HERE")
    else
        preparation_method
        actual_fight
    end 
end

#method for Preping up the player for the fight
def preparation_method
    puts("INPUT ANY KEY TO FIGHT")
    gets.strip
    if $suit == 1
        puts("YOUR ARMOR INCREASES YOUR CHANCES OF SUCCESS\n")
        $danger_level = 3* ($danger_level/4)
        sleep(2)            
    end
    if $axe == 0 and $sword == 0
        puts("YOU HAVE NO WEAPONS\nYOU MUST FIGHT WITH BARE HANDS\n")
        $danger_level += ($danger_level/5)
    elsif
         $axe == 1 and $sword == 0
        puts("YOU HAVE ONLY AN AXE TO FIGHT WITH\n")
        $danger_level = 4 * ($danger_level/5)
    elsif
         $axe == 0 and $sword == 1
        puts("YOU MUST FIGHT WITH YOUR SWORD\n")
        $danger_level = 3* ($danger_level/4)
    else
        puts("WHICH WEAPON WILL YOU USE? 1 - AXE, 2 - SWORD")
        weapon_chosen = gets.strip.to_i
        case weapon_chosen
        when 1
            puts("YOU CHOSE TO FIGHT WITH THE MIGHTY AXE")
            $danger_level = 4 * ($danger_level/5)            
        when 2
            puts("YOU CHOSE TO FIGHT WITH THE DEADLY BLADE")
            $danger_level = 3* ($danger_level/4)
        else
            puts("YOU FAILED TO CHOOSE A WEAPON, YOU WILL FIGHT WITH YOUR BARE HANDS")
            $danger_level += ($danger_level/5)
        end
    end
end

#method for fighting
def actual_fight
    randomnums = Random.new
    loop do  
        sleep(1)
        f_rand = randomnums.rand(1..100)   

        if f_rand>50
            puts("#{$current_mon} ATTACKS\n")
        else
            puts("YOU ATTACK")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>50 and $light==1
            sleep(1)
            puts("YOUR TORCH WAS KNOCKED FROM YOUR HAND\n")
            $light = 0;               
        end       
        
        f_rand = randomnums.rand(1..100)  
        if f_rand>50 and $axe==1
            sleep(1)
            puts("YOU DROP YOUR AXE IN THE HEAT OF BATTLE\n")
            $axe = 0;   
            $danger_level = 5* ($danger_level/4)             
        end   
        
        f_rand = randomnums.rand(1..100)  
        if f_rand>50 and $sword==1
            sleep(1)
            puts("YOUR SWORD IS KNOCKED FROM YOUR HAND!!!\n")
            $sword = 0;   
            $danger_level = 4* ($danger_level/3)             
        end 

        f_rand = randomnums.rand(1..100)  
        if f_rand>50
            sleep(1)
            puts("YOU MANAGE TO WOUND IT\n")
            $danger_level = 5* ($danger_level/6)
            sleep(1)                
        end

        f_rand = randomnums.rand(1..100)  
        
        if f_rand>95
            sleep(1)
            puts("Aaaaargh!!!\nRIP! TEAR! RIP!\n")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>90
            sleep(1)
            puts("YOU WANT TO RUN BUT YOU STAND YOUR GROUND...\n")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>90
            sleep(1)
            puts("*&%%$#$% $%#!! @ #$$# #$@! #$ $#$\n")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)
            puts("WILL THIS BE A BATTLE TO THE DEATH?")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)            
            puts("HIS EYES FLASH FEARFULLY")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)
            puts("BLOOD DRIPS FROM HIS CLAWS")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)
            puts("YOU SMELL THE SULPHUR ON HIS BREATH")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)
            puts("HE STRIKES WILDLY, MADLY...........")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>70
            sleep(1)
            puts("YOU HAVE NEVER FOUGHT AN OPPONENT LIKE THIS!!")
        end

        f_rand = randomnums.rand(1..100)  
        if f_rand>50
            sleep(1)
            puts("\nTHE MONSTER WOUNDS YOU!\n\n")
            $strength -= 5
            sleep(2)                
        end
        f_rand = randomnums.rand(1..100)   
        break if f_rand<=35
    end
    f_rand = randomnums.rand(0..60)      
    if(f_rand>$danger_level)
        puts ("\n YOU MANAGED TO KILL THE #{$current_mon}\n\n")
        $monkills +=1
    else 
       puts("\nTHE #{$current_mon} DEFEATED YOU \n\n")  
       $strength /= 2
    end
    sleep(2)
    set_at_room($roomnumber,6, 0)
end

#Method for Letter R(Run) 
def R
    randomnums = Random.new
    roomn = randomnums.rand(1..100)    
    if roomn>70
        puts "NO, YOU MUST STAND AND FIGHT!"
    else
        puts ("WHICH WAY DO YOU WANT TO FLEE?")
        send(gets.strip.to_sym)
        return "ROOM"
    end
end

#Method for Letter C(Consume) 
def C
    puts "\nYOU HAVE #{$food} UNITS OF FOOD"
    puts "HOW MANY DO YOU WANT TO EAT?"
    wanna_eat = gets.strip.to_i
    if wanna_eat> $food
        puts "THATS MORE FOOD THAN YOU HAVE\n"
    else
        $food = $food-wanna_eat
        $strength = $strength+(5*wanna_eat)
    end
    return "F"    
end

#method for determining if movement is possible and moving if it is.
def move_method(letter_number)

    get_room_stuff(letter_number)
    if (get_room_stuff(letter_number) != 0)
        $roomnumber = get_room_stuff(letter_number)
        $tally    += 1
        $strength -= 5
        if $roomnumber == 9 
            room_9
        end
    else
        case letter_number
            when 0
                puts("NO EXIT THAT WAY")
            when 1
                puts("THERE IS NO EXIT SOUTH")
            when 2
                puts("YOU CANNOT GO IN THAT DIRECTION")                
            when 3
                puts("YOU CANNOT MOVE THROUGH SOLID STONE")
            when 4
                puts("THERE IS NO WAY UP FROM HERE")
            when 5
                puts("YOU CANNOT DESCEND FROM HERE")
        end
    end
    return "ROOM"    
end

#A method for defining what room 9 will do
def room_9
    puts("YOU HAVE ENTERED THE LIFT...")
            sleep(2)
            puts("IT SLOWLY DESCENDS...")
            sleep(4)
            $roomnumber = 10 
end


#Method for Letter N(Going North) 
def N
    move_method(0)
end
 
#Method for Letter S(Going South) 
def S
    move_method(1)    
end

#Method for Letter E(Going East) 
def E
    move_method(2)    
end

#Method for Letter W(Going West)
def W
    move_method(3)   
end

#Method for Letter U(Going Up) 
def U
    move_method(4)   
end

#Method for Letter D(Going Down) 
def D
    move_method(5)   
end

#Method for Letter M(Magic Amulet) 
def M
    randomnums = Random.new
    roomn = randomnums.rand(1...19)    
    while roomn == 6 or roomn == 11
        roomn = randomnums.rand(1...19)  
    end
    puts("
        *
         *
          *
           *
            *
             *
              *")
    $roomnumber = roomn
    if roomn == 9
        room_9
    end
    return "ROOM"
end

#Method for Letter L(Look Around) 
def L
    return "ROOM"
end

#Method for Letter Q(Quit game :(, and calculating final score) 
def Q
    $roomnumber = 0
    score_method
end

#Method for Letter T(Tally, to check current score) 
def T
    score = (3*$tally)+(5*$strength)+(2* $wealth)+($food)+(30*$monkills) 
    puts "YOUR CURRENT SCORE IS #{score}."
end

#Method for Letter H(For displaying help menu)
def H
    puts("YOU CAN ASK ME FOR THE FOLLOWING THINGS:\n")
    puts("N------(GO NORTH)\n")
    puts("S------(GO SOUTH)\n")
    puts("E------(GO EAST)\n")
    puts("W------(GO WEST)\n")
    puts("U------(GO UP)\n")
    puts("D------(GO DOWN)\n")
    puts("I------(ACCESS INVENTORY AND BUY THINGS)\n")
    puts("Q------(QUIT GAME)\n")
    puts("C------(CONSUME FOOD)\n")
    puts("L------(LOOK AROUND TO NOTICE YOUR SORROUNDINGS)\n")
    puts("P------(PICK UP ANYTHING ON THE GROUND)\n")
    puts("F------(FIGHT)\n")
    puts("R------(RUN LIKE A CHICKEN FROM A FIGHT)\n")
    puts("M------(USE YOUR MAGIC AMULET TO TELEPORT TO ANOTHER RANDOM ROOM)\n")
    puts("H------(FOR HELP, AS IN THIS SAME MENU)\n")
    puts("T------(CHECK YOUR TALLY, WHICH IS YOUR CURRENT SCORE)\n")
end

#Method for diplaying Final score 
def score_method    
    score = (3*$tally)+(5*$strength)+(2* $wealth)+($food)+(30*$monkills) 
    puts "YOUR FINAL SCORE IS #{score}."
    puts "\nFAREWELL."
end

game