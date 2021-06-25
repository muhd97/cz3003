extends Area2D

var tile_size = 16
var speed = 6

var cur_direction = Vector2.LEFT
var next_direction	

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _process(_delta):
	if !$Tween.is_active() and next_direction != null:
		position.x = wrapf(position.x, 0, 544)
		
		move()

#This to to play the audio
func play_movementaudio():
	var playermove = get_node("Playermovement")
	playermove.play()

func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		play_movementaudio()
		if event.scancode == KEY_LEFT:
			next_direction = Vector2.LEFT
			
		elif event.scancode == KEY_UP:
			next_direction = Vector2.UP
			
		elif event.scancode == KEY_RIGHT:
			next_direction = Vector2.RIGHT
			
		elif event.scancode == KEY_DOWN:
			next_direction = Vector2.DOWN

func move():
	$RayCast2D.cast_to = next_direction * tile_size
	$RayCast2D.force_raycast_update()
	if !$RayCast2D.is_colliding():
		cur_direction = next_direction
		
		move_tween(cur_direction)
	else:
		if cur_direction == null:
			return
		
		$RayCast2D.cast_to = cur_direction * tile_size
		$RayCast2D.force_raycast_update()
		if !$RayCast2D.is_colliding():
			move_tween(cur_direction)

func move_tween(direction):
	if direction == Vector2.LEFT:
		$AnimatedSprite.rotation_degrees = 0
	elif direction == Vector2.UP:
		$AnimatedSprite.rotation_degrees = 90
	elif direction == Vector2.RIGHT:
		$AnimatedSprite.rotation_degrees = 180
	elif direction == Vector2.DOWN:
		$AnimatedSprite.rotation_degrees = -90
	
	$Tween.interpolate_property(self, "position",
		position, position + direction * tile_size,
		1.0/speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	$Tween.start()
