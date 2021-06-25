extends Control

onready var WorldSectionLabel = get_node("WorldSectionLabel")
onready var ByLabel = get_node("ByLabel")
onready var DescriptionLabel = get_node("DescriptionLabel")

func _ready():
	WorldSectionLabel.text = Variables.selected_world + " - " + Variables.selected_section
	ByLabel.text = Variables.selected_section_by
	DescriptionLabel.text = Variables.selected_section_description

func _on_BackButton_pressed():
	SceneLoader.goto_scene("res://Screens/World Selection Screen/World Selection Screen.tscn")

func _on_StartButon_pressed():
	$HTTPRequest.request(
						"http://172.21.148.167:5000/sections?worldName=" + Variables.selected_world.http_escape() + 
						"&chapterName=" + Variables.selected_section.http_escape()
						)

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print(response_code)
		print(JSON.parse(body.get_string_from_utf8()).result)
	else:
		var section_json = JSON.parse(body.get_string_from_utf8()).result
		
		Variables.playing_section_dict = section_json
		
		SceneLoader.goto_scene("res://Screens/Play Screens/Play Screen.tscn")
