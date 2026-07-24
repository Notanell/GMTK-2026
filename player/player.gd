extends CharacterBody2D

@export var movement_delay = 1.0

#@export var SPEED = 100.0
#const JUMP_VELOCITY = -400.0

#var current_cell = Vector2i(0, 0)

var tilemap : TileMapLayer
var maze : PackedInt32Array
var maze_size : Vector2i
var maze_tileoffset : Vector2i

var can_move = true
var movement_timer = 0
var last_direction : Vector2
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
		if movement_timer > movement_delay || ((direction.is_zero_approx() == false) && (direction != last_direction)):
			tile_movement(direction)
			last_direction = direction
			movement_timer = 0
		movement_timer += _delta


func set_maze_pos(target_cell : Vector2i):
	var target_tile = target_cell + maze_tileoffset
	var target_position = tilemap.to_global(tilemap.map_to_local(target_tile))
	global_position = target_position
	
func tile_movement(dir_input : Vector2i):
	#var current_tile = tilemap.local_to_map(tilemap.to_local(global_position))
	var current_cell = maze_coord
	var target_cell = current_cell + dir_input
	#print(current_tile)
	if target_cell.x >= 0 && target_cell.y >= 0 && target_cell.x < maze_size.x && target_cell.y < maze_size.y:
		for compass in range(MazeHelp.dirs.size()):
			if dir_input == MazeHelp.dirs[compass]:
				if (maze[current_cell.x + (current_cell.y * maze_size.x)] & MazeHelp.CONNECTIONS[compass]) == MazeHelp.CONNECTIONS[compass]:
					var target_tile = target_cell + maze_tileoffset
					var target_position = tilemap.to_global(tilemap.map_to_local(target_tile))
					global_position = target_position
					play_step()
	pass

func play_step():
	$StepAudio.play()
