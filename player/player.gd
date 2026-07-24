extends CharacterBody2D

@export var movement_delay = 0.2

#@export var SPEED = 100.0
#const JUMP_VELOCITY = -400.0

#var current_cell = Vector2i(0, 0)

var tilemap : TileMapLayer
var maze : PackedInt32Array
var maze_size : Vector2i
var maze_tileoffset : Vector2i

var movement_timer = 0
var stored_direction : Vector2

func _physics_process(_delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	movement_timer += _delta
	if stored_direction != direction && direction != Vector2(0, 0):
		stored_direction = direction
	if movement_timer > movement_delay:
		tile_movement(stored_direction)
		stored_direction = Vector2(0, 0)
		movement_timer = 0

func start(pos):
	position = pos
	
func tile_movement(dir_input : Vector2i):
	var current_tile = tilemap.local_to_map(tilemap.to_local(global_position))
	var current_cell = current_tile - maze_tileoffset
	var target_cell = current_cell + dir_input
	#print(current_tile)
	if target_cell.x >= 0 && target_cell.y >= 0 && target_cell.x < maze_size.x && target_cell.y < maze_size.y:
		for compass in range(MazeHelp.dirs.size()):
			if dir_input == MazeHelp.dirs[compass]:
				if (maze[current_cell.x + (current_cell.y * maze_size.x)] & MazeHelp.CONNECTIONS[compass]) == MazeHelp.CONNECTIONS[compass]:
					var target_tile = target_cell + maze_tileoffset
					var target_position = tilemap.to_global(tilemap.map_to_local(target_tile))
					global_position = target_position
	pass
	
	
func fog(state):
	$Fog.visible = state
