extends Area2D

var tile_size = 16
var cur_speed
export var original_speed = 5

var prev_pos
var target
var cur_direction

var scatter = true
var just_switched = false

var switch_mode_timer = 4

export var colour = "red"
export var debug = false

onready var player = $"../Player"

onready var red_home = $"../RedHome"
onready var pink_home = $"../PinkHome"
onready var blue_home = $"../BlueHome"
onready var orange_home = $"../OrangeHome"

onready var red_target_debug = $"../RedTargetDebug"
onready var pink_target_debug = $"../PinkTargetDebug"
onready var blue_target_debug = $"../BlueTargetDebug"
onready var orange_target_debug = $"../OrangeTargetDebug"

onready var all_directions = [{"vector": Vector2.UP, "ray": $UpRayCast},
							{"vector": Vector2.LEFT, "ray": $LeftRayCast},
							{"vector": Vector2.DOWN, "ray": $DownRayCast},
							{"vector": Vector2.RIGHT, "ray": $RightRayCast}]

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
	cur_speed = original_speed
	
	if colour == "red" and debug:
		red_target_debug.visible = true
	elif colour == "pink" and debug:
		pink_target_debug.visible = true
	elif colour == "blue" and debug:
		blue_target_debug.visible = true
	elif colour == "orange" and debug:
		orange_target_debug.visible = true
	
	$AnimatedSprite.playing = true

func _process(delta):
	if debug:
		get_target_position()
	
	if switch_mode_timer >= 0:
		switch_mode_timer -= delta
		
		if switch_mode_timer < 0:
			switch_mode()
	
	if !$Tween.is_active():
		position.x = wrapf(position.x, 0, 544)
		
		var number_of_free_directions = 0
		
		var available_directions = []
		
		# Check which direction has no walls
		for direction in all_directions:
			# If this direction goes to where it came from, skip it
			if prev_pos == position + direction["vector"] * tile_size:
				continue
			
			var ray = direction["ray"]
			ray.force_raycast_update()
			
			if !ray.is_colliding():
				number_of_free_directions += 1
				available_directions.append(direction)
		
		if number_of_free_directions == 1:
			move(available_directions[0]["vector"])
		else:
			var paths_to_player = []
			
			var target_position = get_target_position()
			
			# Check if the mob moves to a direction, how far away is it from its target
			for direction in available_directions:
				var next_pos = position + direction["vector"] * tile_size
				
				var distance = next_pos.distance_to(target_position)
				
				paths_to_player.append({"distance": distance, "vector": direction["vector"]})
			
			var least_distance = 10000
			var chosen_direction
			
			# Check which path has the least distance to its target
			for path in paths_to_player:
				if path["distance"] < least_distance:
					least_distance = path["distance"]
					
					chosen_direction = path["vector"]
			
			move(chosen_direction)

func move(direction):
	prev_pos = position
	
	if just_switched:
		move_tween(cur_direction * -1)
		just_switched = false
	else:
		cur_direction = direction
		move_tween(direction)

func move_tween(direction):
	if direction == Vector2.LEFT:
		$AnimatedSprite.play(colour + "_left")
	elif direction == Vector2.UP:
		$AnimatedSprite.play(colour + "_up")
	elif direction == Vector2.RIGHT:
		$AnimatedSprite.play(colour + "_right")
	elif direction == Vector2.DOWN:
		$AnimatedSprite.play(colour + "_down")
	
	$Tween.interpolate_property(self, "position",
		position, position + direction * tile_size,
		1.0/cur_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	$Tween.start()

func get_target_position():
	if colour == "red":
		if scatter:
			return red_home.position
		else:
			# Red ghost targets the player position
			target = player.position
			
			red_target_debug.position = target
			
			return target
	elif colour == "pink":
		if scatter:
			return pink_home.position
		else:
			# Pink ghost targets where the player is heading
			target = player.position + player.cur_direction * 4 * tile_size
			
			pink_target_debug.position = target
			
			return target
	elif colour == "blue":
		if scatter:
			return blue_home.position
		else:
			# Blue ghost uses targets a position based on player and red ghost positions
			var red_ghost_pos = $"../RedGhost".position
			
			# First is the two tiles ahead of the player
			target = player.position + player.cur_direction * 2 * tile_size
			
			# Then get the red ghost vector distance to that target, multiplied by 2
			var distance = (target - red_ghost_pos) * 2
			
			# Add the distance to the red ghost's position to get the actual target
			target = red_ghost_pos + distance
			
			blue_target_debug.position = target
			
			return target
	elif colour == "orange":
		if scatter:
			return orange_home.position
		else:
			# First, calculate the orange ghost distance to the player
			var distance = position.distance_to(player.position)
			
			# If far away from the player, target it, else target its home
			if distance / tile_size > 8:
				target = player.position
			else:
				target = orange_home.position
			
			orange_target_debug.position = target
			
			return target

func switch_mode():
	scatter = !scatter
	
	just_switched = true
