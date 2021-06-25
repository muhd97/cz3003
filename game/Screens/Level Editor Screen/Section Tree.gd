extends Tree

var root

onready var NumberEasyLabel = get_node("../HBoxContainer/ColorRect/NumberEasyLabel")
onready var NumberMediumLabel = get_node("../HBoxContainer/ColorRect3/NumberMediumLabel")
onready var NumberHardLabel = get_node("../HBoxContainer/ColorRect5/NumberHardLabel")

onready var HTTPRequestNode = $"../HTTPRequest"

var NumberEasy = 0
var NumberMedium = 0
var NumberHard = 0

func _ready():
	# Column for difficulty and checkbox
	self.set_column_expand(0, false)
	self.set_column_min_width(0, 40)
	
	# Column for a), b), c) and d)
	self.set_column_expand(1, false)
	self.set_column_min_width(1, 20)

	root = self.create_item()
	
	create_empty_question(root)
	
	update_all_label_text()

func create_empty_question(parent):
	var question = self.create_item(parent)
	set_difficulty_text(question, null, "[E]")
	question.set_selectable(0, false)
	question.set_text_align(0, 1)
	question.set_tooltip(0, " ")
	
	question.set_selectable(1, false)
	
	question.set_text(2, "Enter question text here...")
	question.set_editable(2, true)
	question.set_tooltip(2, " ")
	
	create_answer(question, "a)")
	create_answer(question, "b)")
	create_answer(question, "c)")
	create_answer(question, "d)")
	
	var blank_row = self.create_item(question)
	blank_row.set_selectable(0, false)
	blank_row.set_selectable(1, false)
	blank_row.set_selectable(2, false)
	blank_row.set_text(2, "-".repeat(500))
	blank_row.set_tooltip(2, " ")
	
	var explanation_row = self.create_item(question)
	explanation_row.set_selectable(0, false)
	explanation_row.set_selectable(1, false)
	explanation_row.set_text(2, "Enter explanation text here...")
	explanation_row.set_editable(2, true)
	explanation_row.set_tooltip(2, " ")
	
	var button = self.create_item(question)
	var texture = ImageTexture.new()
	var icon = load("res://Assets/UI Elements/Buttons/blank.png")
	var image : Image = icon.get_data()
	texture.create_from_image(image)
	
	var eztexture = ImageTexture.new()
	var ezicon = load("res://Assets/UI Elements/Buttons/easy.png")
	var ezimage : Image = ezicon.get_data()
	eztexture.create_from_image(ezimage)

	var medtexture = ImageTexture.new()
	var medicon = load("res://Assets/UI Elements/Buttons/medium.png")
	var medimage : Image = medicon.get_data()
	medtexture.create_from_image(medimage)

	var hardtexture = ImageTexture.new()
	var hardicon = load("res://Assets/UI Elements/Buttons/hard.png")
	var hardimage : Image = hardicon.get_data()
	hardtexture.create_from_image(hardimage)

	button.set_selectable(0, false)
	button.set_selectable(1, false)
	button.set_selectable(2, false)
	button.add_button(2, eztexture, 1, false, "Easy")
	button.add_button(2, medtexture, 2, false, "Medium")
	button.add_button(2, hardtexture, 3, false, "Hard")
	
	# Blank icon to separate the difficulty selector and delete button
	button.add_button(2, texture, 0, false, "BLANK")
	
	var deltexture = ImageTexture.new()
	var delicon = load("res://Assets/UI Elements/Buttons/delete.png")
	var delimage : Image = delicon.get_data()
	deltexture.create_from_image(delimage)
	button.add_button(2, deltexture, 11, false, "Delete Question")

func create_answer(parent, option_identifier):
	var answer = self.create_item(parent)
	answer.set_text(0, "test")
	answer.set_cell_mode(0, 1)
	answer.set_editable(0, true)
	
	answer.set_text(1, option_identifier)
	answer.set_selectable(1, false)
	answer.set_tooltip(1, " ")
	
	answer.set_text(2, "Enter answer text here...")
	answer.set_editable(2, true)
	answer.set_tooltip(2, " ")

func set_difficulty_text(item, cur, next):
	if cur == "[E]":
		NumberEasy -= 1
	elif cur == "[M]":
		NumberMedium -= 1
	elif cur == "[H]":
		NumberHard -= 1
	
	if next == "[E]":
		NumberEasy += 1
	elif next == "[M]":
		NumberMedium += 1
	elif next == "[H]":
		NumberHard += 1
	
	update_all_label_text()
	
	if next != null:
		item.set_text(0, next)

func update_all_label_text():
	NumberEasyLabel.text = str(NumberEasy)
	NumberMediumLabel.text = str(NumberMedium)
	NumberHardLabel.text = str(NumberHard)

func get_last_sibling(child):
	var next = child.get_next()
	
	if next == null:
		return null
	
	while next != null:
		child = next
		next = child.get_next()
	
	return child

func get_all_data():
	var full_json = {"numberEasy":0, "numberMedium":0, "numberHard":0, "questions":[]}
	
	var correct_option = -1
	
	# full_json["numberEasy"] = NumberEasy
	# full_json["numberMedium"] = NumberMedium
	# full_json["numberHard"] = NumberHard
	
	var question_treenode = root.get_children()
	
	if question_treenode == null:
		return {"pass": false, "message": "There are no questions added."}
	
	while question_treenode != null:
		var question_json = {}
		
		question_json["World_Name"] = ""
		question_json["Chapter_name"] = ""
		
		question_json["Question"] = question_treenode.get_text(2)
		question_json["Question_Difficulty"] = question_treenode.get_text(0).substr(1, 1)
		# question_json["answers"] = []
		
		var answer_treenode = question_treenode.get_children()
		
		for i in range(1, 5):
			var answer_text = answer_treenode.get_text(2)
			var answer_correct = answer_treenode.is_checked(0)
			
			if answer_correct:
				correct_option = i
			
			# question_json["answers"].append(answer_text)
			question_json["Question_Opt" + str(i)] = answer_text
			
			answer_treenode = answer_treenode.get_next()
		
		if correct_option == -1:
			return {"pass": false, "message": "The question '" + question_treenode.get_text(2) + "' needs a correct option selected."}
		else:
			question_json["Correct_Opt"] = correct_option
			
			correct_option = -1
		
		var explanation_treenode = answer_treenode.get_next()
		question_json["Explanation"] = explanation_treenode.get_text(2)
		
		full_json["questions"].append(question_json)
		
		question_treenode = question_treenode.get_next()
	
	return {"pass": true, "message": full_json}

func _on_Tree_button_pressed(item, _column, id):
	if id == 1:
		set_difficulty_text(item.get_parent(), item.get_parent().get_text(0), "[E]")
	elif id == 2:
		set_difficulty_text(item.get_parent(), item.get_parent().get_text(0), "[M]")
	elif id == 3:
		set_difficulty_text(item.get_parent(), item.get_parent().get_text(0), "[H]")
	elif id == 11:
		set_difficulty_text(item.get_parent(), item.get_parent().get_text(0), null)
		item.get_parent().free()

func _on_Add_Question_Button_pressed():
	create_empty_question(root)
