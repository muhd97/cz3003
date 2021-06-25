# API Endpoints

# Notes
If endpoint fails, check if there is a space between the query strings. Not sure if godot auto adds the space, if not add %20 for the space in query string  

## Player
#### Create account
POST http://172.21.148.167:5000/playerinfo  
{"Player_name" = "REQUIRED", "Password": "REQUIRED", "Major": "REQUIRED", "Year": "REQUIRED", "Character_Code": "REQUIRED", "Role": "REQUIRED"}

#### Login
POST http://172.21.148.167:5000/login  
{"Player_name" = "REQURIED", "Password": "REQUIRED"}  

#### retrieve all played sections and score
GET http://172.21.148.167:5000/playersscore?playerName=NAME

#### insert new score
POST http://172.21.148.167:5000/playersscore  
{"playerName": "REQUIRED", "worldName": "REQUIRED", "chapterName": "REQUIRED", "score": "REQUIRED"}

#### update score
PATCH http://172.21.148.167:5000/playersscore  
{"score": "REQUIRED", "playerName": "REQUIRED", "worldName": "REQUIRED", "chapterName": "REQUIRED"}

#### delete score
DELETE http://172.21.148.167:5000/playersscore  
{"playerName": "REQUIRED", "worldName": "REQUIRED", "chapterName": "REQUIRED"}


## Worlds
#### Get all worlds, sections and leaderboard
GET http://172.21.148.167:5000/worlds?playerName=Sunny

#### Get all worlds
GET http://172.21.148.167:5000/worldinfo?worldName=OPTIONAL  

#### Create new world
POST http://172.21.148.167:5000/worldinfo  
{"World_Name": "REQUIRED", "Chpt_Name": "REQUIRED", "WorldInfocol": "REQUIRED", "Created_By": "REQUIRED"}  

#### Update world
PATCH http://172.21.148.167:5000/worldinfo  
{"World_Name": "REQUIRED", "Chpt_Name": "REQURIED", "WorldInfocol": "OPTIONAL", "Created_By": "OPTIONAL"}  

#### Delete world
DELETE http://172.21.148.167:5000/worldinfo  
{"World_Name": "REQUIRED", "Chpt_Name": "REQURIED"}  


## Sections and levels
#### Get all sections and levels  
GET http://172.21.148.167:5000/sections?worldName=CZ2006_SE&chapterName=Dynamic%20Model
