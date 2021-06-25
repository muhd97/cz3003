extends Control

onready var ScoreLabel = get_node("ScoreLabel")
onready	var currentWorld = Variables.selected_world
onready	var currentSection = Variables.selected_section

func _ready():
	ScoreLabel.text = "Score: " + str(Variables.playing_score)
	
	run_HTTPRequest(HTTPClient.METHOD_POST)

func _on_ShareButton_pressed():
	OS.shell_open("https://twitter.com/intent/tweet?text=Check out my Highscore in World "+currentWorld+" and section "+currentSection+" LearnIT "+ScoreLabel.text+"&hashtags=learningisfun")

func run_HTTPRequest(method):
	var url = "http://172.21.148.167:5000/playersscore"
	var data = {
				"playerName": Variables.username,
				"worldName": Variables.selected_world,
				"chapterName": Variables.selected_section,
				"score": Variables.playing_score}
	
	# Godot auto converts any \n to \\n, so change it back to \n
	var query = JSON.print(data, "\t").replace("\\\\n", "\\n")
	
	var use_ssl = true
	var headers = ["Content-Type: application/json"]
	
	$HTTPRequest.request(url, headers, use_ssl, method, query)

func _on_BackButton_pressed():
	SceneLoader.goto_scene("res://Screens/World Selection Screen/World Selection Screen.tscn")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code == 400:
		run_HTTPRequest(HTTPClient.METHOD_PATCH)
	elif response_code != 200:
		print(response_code)
		print(JSON.parse(body.get_string_from_utf8()).result)
		$WaitingLabel.text = "Failed to submit!"
	else:
		$WaitingLabel.visible = false
		$BackButton.visible = true
		$ShareButton.visible = true
