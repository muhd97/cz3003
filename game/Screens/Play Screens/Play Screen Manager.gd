extends Control

onready var WorldSectionLabel = get_node("WorldSectionLabel")
onready var ByLabel = get_node("ByLabel")

onready var CurLevelLabel = get_node("CurLevelLabel")

onready var ScoreLabel = get_node("ScoreLabel")
onready var TimerLabel = get_node("TimerLabel")

onready var ExplanationScroll = get_node("ExplanationScroll")
onready var ExplanationLabel = get_node("ExplanationScroll/ExplanationLabel")

onready var QuestionLabel = get_node("QuestionLabel")
onready var Answer1Checkbox = get_node("VBoxContainer/Answer1Checkbox")
onready var Answer2Checkbox = get_node("VBoxContainer/Answer2Checkbox")
onready var Answer3Checkbox = get_node("VBoxContainer/Answer3Checkbox")
onready var Answer4Checkbox = get_node("VBoxContainer/Answer4Checkbox")

onready var ContinueButton = get_node("ContinueButton")

var all_questions_dict = {}

var difficulty = ""
var correct_option = 0

var cur_level = 0

var timeRemaining = Variables.playing_time_in_seconds

var correct_style = load("res://Assets/Styleboxes/GreenWithTransparentBorder.tres")
var wrong_style = load("res://Assets/Styleboxes/RedWithTransparentBorder.tres")
var default_style = load("res://Assets/Styleboxes/TransparentWithTransparentBorder.tres")

export(PackedScene) var typing_game_scene
export(PackedScene) var maze_game_scene

var loaded_minigame_scene

func _ready():
	WorldSectionLabel.text = Variables.selected_world + " - " + Variables.selected_section
	ByLabel.text = Variables.selected_section_by
	
	TimerLabel.text = "Timer: " + str(timeRemaining)
	
	Variables.total_levels = Variables.playing_section_dict["questions"].size()
	Variables.playing_score = 0
	
	load_question(cur_level)

func load_question(index):
	var question_dict = Variables.playing_section_dict["questions"][index]
	
	ExplanationLabel.text = question_dict["explanation"]
	
	QuestionLabel.text = question_dict["text"]
	Answer1Checkbox.text = "[A] " + question_dict["answers"][0]
	Answer2Checkbox.text = "[B] " + question_dict["answers"][1]
	Answer3Checkbox.text = "[C] " + question_dict["answers"][2]
	Answer4Checkbox.text = "[D] " + question_dict["answers"][3]
	
	difficulty = question_dict["difficulty"]
	
	correct_option = question_dict["correct"]
	
	cur_level += 1
	
	CurLevelLabel.text = "Level " + str(cur_level) + " / " + str(Variables.total_levels)
	
	randomize()
	
	var rand_int = randi() % 2
	
	if rand_int == 0:
		# Typing Minigame
		load_minigame(typing_game_scene)
		
		var array_of_answers = [question_dict["answers"][0],
								question_dict["answers"][1],
								question_dict["answers"][2],
								question_dict["answers"][3]]
		
		loaded_minigame_scene.spawn_mobs(array_of_answers)
	elif rand_int == 1:
		# Maze Minigame
		load_minigame(maze_game_scene)

func press_checkbox(box_index):
	if box_index == 1:
		Answer1Checkbox.pressed = true
	elif box_index == 2:
		Answer2Checkbox.pressed = true
	elif box_index == 3:
		Answer3Checkbox.pressed = true
	elif box_index == 4:
		Answer4Checkbox.pressed = true

func unpress_all_checkboxes():
	Answer1Checkbox.pressed = false
	Answer2Checkbox.pressed = false
	Answer3Checkbox.pressed = false
	Answer4Checkbox.pressed = false

func load_minigame(scene):
	var loaded_scene = scene.instance()
	add_child(loaded_scene)
	
	loaded_scene.position = Vector2(300, 178)
	loaded_scene.scale = Vector2(0.8, 0.8)
	
	move_child(loaded_scene, 0)
	
	loaded_minigame_scene = loaded_scene

func update_score(score):
	var cur_score = int(ScoreLabel.text.substr(6, -1))
	
	Variables.playing_score = cur_score + score
	
	ScoreLabel.text = "Score: " + str(cur_score + score)

func _on_Timer_timeout():
	timeRemaining -= 1
	
	if timeRemaining >= 0:
		TimerLabel.text = "Timer: " + str(timeRemaining)
		
		if timeRemaining == 0:
			SceneLoader.goto_scene("res://Screens/Play Screens/Play Finish Screen.tscn")

func submit(selected_option):
	loaded_minigame_scene.queue_free()

	ExplanationScroll.visible = true
	ContinueButton.visible = true
	
	press_checkbox(selected_option)
	
	if selected_option == correct_option:
		# Adds green background to selected option
		if selected_option == 1:
			Answer1Checkbox.add_stylebox_override("disabled", correct_style)
		elif selected_option == 2:
			Answer2Checkbox.add_stylebox_override("disabled", correct_style)
		elif selected_option == 3:
			Answer3Checkbox.add_stylebox_override("disabled", correct_style)
		elif selected_option == 4:
			Answer4Checkbox.add_stylebox_override("disabled", correct_style)
		
		if difficulty == "E":
			update_score(1)
		elif difficulty == "M":
			update_score(3)
		elif difficulty == "H":
			update_score(7)
	else:
		# Adds green background to correct option
		if correct_option == 1:
			Answer1Checkbox.add_stylebox_override("disabled", correct_style)
		elif correct_option == 2:
			Answer2Checkbox.add_stylebox_override("disabled", correct_style)
		elif correct_option == 3:
			Answer3Checkbox.add_stylebox_override("disabled", correct_style)
		elif correct_option == 4:
			Answer4Checkbox.add_stylebox_override("disabled", correct_style)
		
		# Adds red background to selected wrong option
		if selected_option == 1:
			Answer1Checkbox.add_stylebox_override("disabled", wrong_style)
		elif selected_option == 2:
			Answer2Checkbox.add_stylebox_override("disabled", wrong_style)
		elif selected_option == 3:
			Answer3Checkbox.add_stylebox_override("disabled", wrong_style)
		elif selected_option == 4:
			Answer4Checkbox.add_stylebox_override("disabled", wrong_style)

func _on_ContinueButton_pressed():
	ExplanationScroll.scroll_vertical = 0
	ExplanationScroll.visible = false
	ContinueButton.visible = false
	
	unpress_all_checkboxes()
	
	# Removes the backgrounds
	Answer1Checkbox.add_stylebox_override("disabled", default_style)
	Answer2Checkbox.add_stylebox_override("disabled", default_style)
	Answer3Checkbox.add_stylebox_override("disabled", default_style)
	Answer4Checkbox.add_stylebox_override("disabled", default_style)
	
	if cur_level == Variables.total_levels:
		SceneLoader.goto_scene("res://Screens/Play Screens/Play Finish Screen.tscn")
	else:
		load_question(cur_level)
