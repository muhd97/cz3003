extends RigidBody2D

var text = "test"
var typed_color = "#DA70D6"

var off_screen = false

func _ready():
	randomize()
	
	var colours = ["Beige", "Blue", "Green", "Pink", "Yellow"]
	
	var chosen_colour = colours[randi() % colours.size()]
	
	$AnimatedSprite.play(chosen_colour)
	
	update_text(0)

func _process(_delta):
	rotation_degrees = 0
	
	if linear_velocity.x < 0:
		$AnimatedSprite.scale.x = -0.25
	else:
		$AnimatedSprite.scale.x = 0.25

func delete_self():
	queue_free()

func update_text(color_index):
	var color_text = "[color=" + typed_color + "]" + text.left(color_index) + "[/color]"
	
	$RichTextLabel.bbcode_text = "[center]" + color_text + text.substr(color_index) + "[/center]"

func force_downwards():
	if !off_screen:
		linear_velocity.y = -300
		gravity_scale = 10
