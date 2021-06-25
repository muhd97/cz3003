extends Node2D

export(PackedScene) var mob_scene

var answers_dict = [{"mob": null, "text": "", "typed_index": 0},
					{"mob": null, "text": "", "typed_index": 0},
					{"mob": null, "text": "", "typed_index": 0},
					{"mob": null, "text": "", "typed_index": 0}]

var correct_answer = ""

var number_alive = 4

var disable_keyboard_input = false

var selected_option

func _ready():
	if get_parent().name != "PlayControl":
		answers_dict[0]["text"] = "answer1"
		answers_dict[1]["text"] = "ans2"
		answers_dict[2]["text"] = "b3"
		answers_dict[3]["text"] = "1nswerer4"
		
		correct_answer = "1nswerer4"
		
		spawn_mobs(answers_dict)

func _unhandled_input(event) -> void:
	if disable_keyboard_input:
		return
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.scancode == KEY_ESCAPE:
			for mob_dict in answers_dict:
				mob_dict["typed_index"] = 0
			
			get_tree().call_group("aliens", "update_text", 0)
		
		if event.scancode == KEY_ENTER:
			disable_keyboard_input = true
			get_tree().call_group("aliens", "force_downwards")

		var key_typed = PoolByteArray([event.unicode]).get_string_from_utf8()
		
		var i = 1
		
		for answer in answers_dict:
			var next_character = answer["text"].substr(answer["typed_index"], 1)
			
			if key_typed == next_character:
				answer["typed_index"] += 1
				
				if answer["typed_index"] == answer["text"].length():
					answer["typed_index"] = 0
					
					if get_parent().name != "PlayControl":
						$AnswerLabel.text = answer["text"]
					else:
						selected_option = i
						
						get_parent().press_checkbox(selected_option)
			
			i += 1
			
			answer["mob"].update_text(answer["typed_index"])

func _on_Area2D_body_entered(body):
	number_alive -= 1
	
	body.off_screen = true
	
	if number_alive == 0:
		get_tree().call_group("aliens", "delete_self")
		
		if get_parent().name != "PlayControl":
			check_correct()
		else:
			get_parent().submit(selected_option)

func spawn_mobs(answers_array):
	var win_size = 544
	
	for i in range(0, 4):
		answers_dict[i]["text"] = answers_array[i].to_lower()
		
		var mob = mob_scene.instance()
		add_child(mob)
		
		answers_dict[i]["mob"] = mob
		
		var x_position = win_size / 5 * (i + 1) + rand_range(-100, 100)
		mob.position = Vector2(x_position, 100)
		
		var x_velocity = rand_range(40, 100)
		if randf() <= 0.5:
			x_velocity *= -1
			
		var velocity = Vector2(x_velocity, rand_range(-35, -25))
		mob.linear_velocity = velocity
		
		mob.text = answers_dict[i]["text"]
		
		mob.update_text(0)

func check_correct():
	if $AnswerLabel.text == correct_answer:
		$CorrectOrWrongLabel.text = "Correct"
	else:
		$CorrectOrWrongLabel.text = "Wrong"
