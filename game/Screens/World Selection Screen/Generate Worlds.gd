extends TabContainer

const PADDING_TAB_NAME = 10

var scene = load("res://Screens/World Selection Screen/World Selection.tscn")

onready var HTTPRequestNode = $"../HTTPRequest"

func _ready():
	HTTPRequestNode.request("http://172.21.148.167:5000/worlds?playerName=" + Variables.username)

func convert_json_to_worlds(worlds_json):
	var worlds = worlds_json["worlds"]
	
	for world in worlds:
		add_world(world["name"], world["sections"], world["rankings"])
	
	# Add margin to the world names for the tab container
	for tab_index in range(0, get_tab_count()):
		var tab_title = get_tab_title(tab_index)
		
		var tab_name_size = tab_title.length()
		var half_pad = ceil((PADDING_TAB_NAME + tab_name_size) / 2.0)
		var tab_title_padded = '%*s' % [half_pad, tab_title]
		
		tab_title_padded = '%-*s' % [PADDING_TAB_NAME, tab_title_padded]
		
		set_tab_title(tab_index, tab_title_padded)
	
	self.current_tab = Variables.selected_world_index

func add_world(name, sections, rankings):
	var node = scene.instance()
	add_child(node)
	
	node.name = name
	
	node.sections = sections
	node.add_sections()
	
	node.rankings = rankings
	node.add_rankings()

func _on_GoToCreateButton_pressed():
	SceneLoader.goto_scene("res://Screens/Level Editor Screen/Level Editor Screen.tscn")

# All requests will call this function upon completion
func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print(response_code)
		print(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var worlds_json = JSON.parse(body.get_string_from_utf8()).result
		
		convert_json_to_worlds(worlds_json)
