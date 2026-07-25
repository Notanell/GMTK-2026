extends CharacterBody2D

@export var movement_delay = 0.2
var delay_before_movement_can_be_stored = 0.1
var stored_direction_movement_extradelay = 0.1
#@export var SPEED = 100.0
#const JUMP_VELOCITY = -400.0

#var current_cell = Vector2i(0, 0)

var tilemap : TileMapLayer
var maze : PackedInt32Array
var maze_size : Vector2i
var maze_tileoffset : Vector2i

var can_move = true # used 
var movement_timer = 0
var _movement_allowed = false
var stored_direction : Vector2 # stored to execute on timeout
var last_direction : Vector2 # the direction the last movement was made in
var maze_coord : Vector2i:
	get:
		return tilemap.local_to_map(tilemap.to_local(global_position)) - maze_tileoffset


func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	if can_move == true:
		movement_timer += _delta
		if movement_timer > movement_delay:
			_movement_allowed = true
		if _movement_allowed:
			var success = false
			if direction.is_zero_approx() == false:
				success = tile_movement(direction)
			elif direction.is_zero_approx() && (stored_direction.is_zero_approx() == false) && (movement_timer > (movement_delay + stored_direction_movement_extradelay)):
				success = tile_movement(stored_direction)
			if success:
				stored_direction = Vector2(0, 0)
				movement_timer = 0
				_movement_allowed = false
		#if _movement_allowed == false:
		elif direction.is_zero_approx() == false && movement_timer > delay_before_movement_can_be_stored:
			stored_direction = direction
		#print(movement_timer)


func set_maze_pos(target_cell : Vector2i):
	var target_tile = target_cell + maze_tileoffset
	var target_position = tilemap.to_global(tilemap.map_to_local(target_tile))
	global_position = target_position
	
func tile_movement(dir_input : Vector2i) -> bool:
	#var current_tile = tilemap.local_to_map(tilemap.to_local(global_position))
	var current_cell = maze_coord
	var target_cell = current_cell + dir_input
	#print(current_tile)
	if target_cell.x >= 0 && target_cell.y >= 0 && target_cell.x < maze_size.x && target_cell.y < maze_size.y:
		for compass in range(MazeHelp.dirs.size()):
			if dir_input == MazeHelp.dirs[compass]: # check the directional input exists within the allowed directions
				if (maze[current_cell.x + (current_cell.y * maze_size.x)] & MazeHelp.CONNECTIONS[compass]) == MazeHelp.CONNECTIONS[compass]: # now check if that move is actually valid
					var target_tile = target_cell + maze_tileoffset
					var target_position = tilemap.to_global(tilemap.map_to_local(target_tile))
					global_position = target_position
					play_step()
					return true
	return false

func play_step():
	$StepAudio.play()
