extends Node2D

func _on_Player_area_entered(area):
	if "Ghost" in area.name:
		if get_parent().name != "PlayControl":
			print("die")
		else:
			get_parent().submit(-1)
	elif "Option" in area.name:
		if get_parent().name != "PlayControl":
			$AnswerLabel.text = area.name.right(6)
		else:
			var answer = area.name.right(6)
			
			if answer == "A":
				get_parent().submit(1)
			elif answer == "B":
				get_parent().submit(2)
			elif answer == "C":
				get_parent().submit(3)
			elif answer == "D":
				get_parent().submit(4)
