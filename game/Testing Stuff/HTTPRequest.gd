extends CanvasLayer

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
	# POST
	var url = "http://172.21.148.167:5000/login"
	var data_to_send = {"Player_name": "dog", "Password": "12"}
	var use_ssl = true
	
	_make_post_request(url, data_to_send, use_ssl)

# GET
func _on_Button_pressed():
	$HTTPRequest.request("http://172.21.148.167:5000/sections?worldName=CZ2006_SE&chapterName=Dynamic%20Model")

# All requests will call thsi function upon completion
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
