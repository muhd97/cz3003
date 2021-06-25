extends Control

onready var TitleLabel = get_node("Selected/TitleLabel")
onready var ByLabel = get_node("Selected/ByLabel")
onready var DescriptionLabel = get_node("Selected/DescriptionLabel")

onready var RankingsContainer = get_node("LeaderboardContainer/ScrollContainer/RankingsContainer")

onready var ExampleRankLabel = get_node("LeaderboardContainer/ScrollContainer/RankingsContainer/ExampleRankLabel")
onready var ExampleNameLabel = get_node("LeaderboardContainer/ScrollContainer/RankingsContainer/ExampleNameLabel")
onready var ExampleScoreLabel = get_node("LeaderboardContainer/ScrollContainer/RankingsContainer/ExampleScoreLabel")

onready var PlayerRankLabel = get_node("LeaderboardContainer/PlayerRankContainer/PlayerRankLabel")
onready var PlayerNameLabel = get_node("LeaderboardContainer/PlayerRankContainer/PlayerNameLabel")
onready var PlayerScoreLabel = get_node("LeaderboardContainer/PlayerRankContainer/PlayerScoreLabel")

onready var ErrorMessageLabel = get_node("LeaderboardContainer/ErrorMessageLabel")

var sections = []
var cur_selected_section_index = 0

var rankings = {}

func add_sections():
	var ItemList = get_node("ScrollContainer/ItemList")
	
	for section in sections:
		ItemList.add_item(section["name"])
	
	# If no selection has been made before (first time loading), set to 0,
	# else use previous selection
	if Variables.selected_section_indexes.size() == 0:
		ItemList.select(0)
		_on_ItemList_item_selected(0)
	else:
		var pos = Variables.selected_section_indexes.pop_front()

		ItemList.select(pos)
		_on_ItemList_item_selected(pos)

func add_rankings():
	PlayerNameLabel.text = Variables.username
	
	if rankings.size() == 0:
		ErrorMessageLabel.visible = true
		
		return
	
	if rankings["player"].size() != 0:
		PlayerRankLabel.text = str(rankings["player"]["rank"])
		PlayerScoreLabel.text = str(rankings["player"]["score"])
	
	var top_players = rankings["top_players"]
	
	for top_player in top_players:
		var newRankLabel = ExampleRankLabel.duplicate()
		RankingsContainer.add_child(newRankLabel)
		newRankLabel.text = str(top_player["rank"])
		newRankLabel.visible = true
		
		var newNameLabel = ExampleNameLabel.duplicate()
		RankingsContainer.add_child(newNameLabel)
		newNameLabel.text = top_player["name"]
		newNameLabel.visible = true
		
		var newScoreLabel = ExampleScoreLabel.duplicate()
		RankingsContainer.add_child(newScoreLabel)
		newScoreLabel.text = str(top_player["score"])
		newScoreLabel.visible = true

func _on_ItemList_item_selected(index):
	cur_selected_section_index = index
	
	TitleLabel.text = sections[index]["name"]
	ByLabel.text = "By: " + sections[index]["by"]
	DescriptionLabel.text = sections[index]["description"]

func _on_PlayButton_pressed():
	var tab_container = self.get_parent()
	
	# To return the user to what they have previously selected:
	# Retrieve current world selection and store in global variable
	Variables.selected_world_index = tab_container.current_tab
	
	# Retrieve each world's selection section and store in global variable
	var item_list
	for child in tab_container.get_children():
		item_list = child.get_node("ScrollContainer/ItemList")
		
		Variables.selected_section_indexes.append(item_list.get_selected_items()[0])
	
	Variables.selected_world = self.name
	Variables.selected_section = TitleLabel.text
	Variables.selected_section_by = ByLabel.text
	Variables.selected_section_description = DescriptionLabel.text
	
	SceneLoader.goto_scene("res://Screens/Play Screens/Play Preparation Screen.tscn")

func _on_LeaderboardButton_pressed():
	var parent = self.get_parent()
	
	var all_siblings = parent.get_children()
	
	for sibling in all_siblings:
		sibling.get_node("LeaderboardContainer").visible = !sibling.get_node("LeaderboardContainer").visible

func _on_AnalyticsButton_pressed():
	OS.shell_open("http://172.21.148.167:4000/")
