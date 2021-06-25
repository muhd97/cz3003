extends Control

onready var MessageLabel = get_node("ColorRect2/MessageLabel")

onready var SectionName = get_node("ColorRect2/VBoxContainer/Name")
onready var SectionDescription = get_node("ColorRect2/VBoxContainer/Description")

onready var ShareButton = get_node("ColorRect2/ShareButton")

var result
var requests_completed = 0

var use_ssl = true
var headers = ["Content-Type: application/json"]

func _on_Save_Data_pressed():
	result = get_node("Section Editor/Tree").get_all_data()
	
	if result["pass"]:
		# Save the section to Custom world
		
		
		var url = "http://172.21.148.167:5000/worldinfo"
		var data = {
					"World_Name": "Custom",
					"Chpt_Name": SectionName.text,
					"WorldInfocol": SectionDescription.text,
					"Created_By": Variables.username}
		
		# Godot auto converts any \n to \\n, so change it back to \n
		var query = JSON.print(data, "\t").replace("\\\\n", "\\n")
		
		$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
		
	else:
		MessageLabel.text = result["message"]
		MessageLabel.visible = true

func _on_GoToPlayButton_pressed():
	SceneLoader.goto_scene("res://Screens/World Selection Screen/World Selection Screen.tscn")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print(response_code)
		print(JSON.parse(body.get_string_from_utf8()).result)
		
		MessageLabel.text = "Error saving the questions to database."
	else:
		requests_completed += 1
		
		if requests_completed == 2:
			MessageLabel.text = "Questions saved."
			requests_completed = 0
			
			ShareButton.visible = true
		else:
			# Store the questions in the Question Bank
			var url = "http://172.21.148.167:5000/questionbank"
			
			var data = result["message"]["questions"]
			
			for question in data:
				question["World_Name"] = "Custom"
				question["Chapter_name"] = SectionName.text
			
			# Godot auto converts any \n to \\n, so change it back to \n
			var query = JSON.print(data, "\t").replace("\\\\n", "\\n")
				
			$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
	MessageLabel.visible = true

func _on_ShareButton_pressed():
	OS.shell_open(
				"http://172.21.148.167:3000/?worldName=" + "Custom" +
				"&chapterName=" + SectionName.text.http_escape()
				)
