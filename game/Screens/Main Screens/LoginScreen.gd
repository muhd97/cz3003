extends Control

export (NodePath) var dropdown_path

onready var username = get_node("NinePatchRect/VBoxContainer/Username")
onready var password = get_node("NinePatchRect/VBoxContainer/Password")
onready var notification : Label = $NinePatchRect/VBoxContainer/Notification 

func _on_LoginButton_pressed():
	print(username.text)
	print(password.text)
	
	#Loading Scene
	notification.text = "Please wait..."
	
	var url = "http://172.21.148.167:5000/login"
	var data_to_send = {'Player_name':username.text,'Password':password.text}
	var use_ssl = true
	
		# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	#User input error handling
	if response_code == 0:
		print(response_code)
		notification.text = "Please ensure NTU VPN is connected"
	elif response_code != 200:
		print(response_code)
		notification.text = "Please enter valid username and password"
	elif response_code == 200:
		notification.text = "Login Successful"
		SceneLoader.goto_scene("res://Screens/World Selection Screen/World Selection Screen.tscn")
	
		var json = JSON.parse(body.get_string_from_utf8())
		print(json.result[0]["Role"])
		#If Role = Student
		if json.result[0]["Role"] == "S":
			Variables.admin = false
		#If Role = Admin
		elif json.result[0]["Role"] == "A":
			Variables.admin = true
