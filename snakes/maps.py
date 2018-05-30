# Final Project: Werewolves and Wanderer
# Date: 02-May-2018
# Authors:
#          A01374526 Jose Karlo Hurtado Corona
#          A01373890 Gabriela Aguilar Lugo

import yaml
import json
from flask import Flask
app = Flask(__name__)

the_big_yaml = 0
particular_y = 0

#position number to string converter
def pos_to_string(pos):
    maker = {
        0: "north",
        1: "south",
        2: "east",
        3: "west",
        4: "up",
        5: "down",
        6: "contents"
    }
    return maker.get(pos, "No Direction")

#method for getting a position from the xaml
def formatting(myyaml, id, pos):
    pos = pos_to_string(pos)
    some_cool_dictionary_with_a_long_name = 0
    counter1 = 0
    for x in myyaml:
        if counter1 == id:
            particular_y = x
        counter1 += 1

    for y in particular_y:
        if y == pos:
            some_cool_dictionary_with_a_long_name = {
                y: particular_y[y]
            }
            return json.dumps(some_cool_dictionary_with_a_long_name)  
            #print(y) 

#method for getting and setting a position on the xaml
def formatting2(myyaml, id, pos, new_val):
    pos = pos_to_string(pos)
    some_cool_dictionary_with_a_long_name = 0
    counter1 = 0
    for x in myyaml:
        if counter1 == id:
            for y in x:
                if y == pos:
                    #print(x[y]) 
                    x[y] = new_val
                    some_cool_dictionary_with_a_long_name = {
                        "ok": "everything is cool and good"
                    }
                    #print(y) 
                    #print(x[y]) 
                    the_big_yaml = myyaml 
                    #print(the_big_yaml)
                    return json.dumps(some_cool_dictionary_with_a_long_name)
        counter1 += 1
  
#method for getting the element on a position
@app.route('/maps/<int:my_id>/<int:the_pos>')
def mapParts(my_id,the_pos):
    with open("map.yml", 'r') as stream:
        try:
            the_big_yaml = yaml.load(stream)
            possible = formatting(the_big_yaml,my_id,the_pos)
            return possible
        except yaml.YAMLError as exc:
            print(exc)
    return 'cheers, love'

#method for setting the element on a position
@app.route('/setmaps/<int:my_id>/<int:the_pos>/<int:new_one>')
def mapPart(my_id,the_pos,new_one):
    possible = 0
    with open("map.yml", 'r') as stream:
        try:
            the_big_yaml = yaml.load(stream)
            possible = formatting2(the_big_yaml,my_id,the_pos,new_one)
        except yaml.YAMLError as exc:
            print(exc)
    with open("map.yml", 'w') as yaml_file:
        try:
            yaml.dump(the_big_yaml, yaml_file, default_flow_style=False)
        except yaml.YAMLError as exc:
            print(exc)
    return possible

#method for setting basic castle 
@app.route('/zeroout')
def zeroOut():
    #print "ok"
    with open("mapzero.yml", 'r') as stream:
        try:
            the_big_yaml = yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)

    with open("map.yml", 'w') as yaml_file:
        try:
            yaml.dump(the_big_yaml, yaml_file, default_flow_style=False)
        except yaml.YAMLError as exc:
            print(exc)
    some_cool_dictionary_with_a_long_name = {
        "ok": "everything is cool and good"
    }
    return json.dumps( some_cool_dictionary_with_a_long_name)

#method for initializing 
if __name__ == '__main__':
   app.run(port = 8083)


