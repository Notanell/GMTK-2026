extends Node2D

var MazeGenerator = MazeGen.new()
var maze_size = Vector2i(18, 15)
var maze_tileoffset = Vector2i(1, 1)
var maze : PackedInt32Array
var maze_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_maze(maze_size_input:Vector2i, start_cell:Vector2i, end_cell := Vector2i(-1, -1), key_cell := Vector2i(-1, -1)) -> Array[Vector2i]:
	maze_ready = false
	maze_size = maze_size_input
	#if maze_size.x > maze_maxsize.x:
		#maze_size.x = maze_maxsize.x
	#if maze_size.y > maze_maxsize.y:
		#maze_size.y = maze_maxsize.y
	
	if end_cell == Vector2i(-1, -1): # only choose a random end cell if one isn't provided
		end_cell = select_end_cell(start_cell)
	if key_cell == Vector2i(-1, -1): # only choose a random end cell if one isn't provided
		key_cell = select_key_cell(start_cell, end_cell)
	
	maze = MazeGenerator.generate_maze(maze_size, start_cell, end_cell, key_cell)
	for y in range(maze_size.y):
		#var printstring : String = ''
		for x in range(maze_size.x):
			#var num_str = String.num_int64(maze[x + (y * maze_size.x)], 2)
			#printstring += num_str.pad_zeros(4)
			#printstring += ', '
			var cell = maze[x + (y * maze_size.x)]
			place_tile(Vector2i(x, y), cell)
		#print(printstring)
	maze_ready = true
	return [end_cell, key_cell]

func place_tile(pos: Vector2i, cell : int):
	if ((cell & MazeHelp.startend_mask) == MazeHelp.tiletype_binary['START']):
		$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord['START'])
		return
	elif ((cell & MazeHelp.startend_mask) == MazeHelp.tiletype_binary['END']):
		$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord['END'])
		return
	elif ((cell & MazeHelp.startend_mask) == MazeHelp.tiletype_binary['KEY']):
		$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord['KEY'])
		return
	for key in MazeHelp.tiletype_binary.keys():
		if (cell & MazeHelp.connect_mask) == MazeHelp.tiletype_binary[key]:
			$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord[key])
			break
			
func currentdistance_fromtarget(from_cell, to_cell):
	return MazeGenerator.dist_to_target(from_cell, to_cell)
		
func select_end_cell(start_cell : Vector2i) -> Vector2i: # start cell provided to ensure that the end cell is a decent distance away
	# choose the wall furthest from the start cell
	var dists : Array[int] = [maze_size.x - start_cell.x, maze_size.y - start_cell.y, start_cell.x, start_cell.y] # ESWN
	var side = dists.find(dists.max())
	if side == 0:
		return Vector2i(maze_size.x - 1, randi_range(0, maze_size.y - 1))
	elif side == 1:
		return Vector2i(randi_range(0, maze_size.x - 1), maze_size.y - 1)
	elif side == 2:
		return Vector2i(0, randi_range(0, maze_size.y - 1))
	elif side == 3:
		return Vector2i(randi_range(0, maze_size.x - 1), 0)
	else:
		return maze_size - Vector2i(1, 1) # this shouldn't ever happen

func select_key_cell(start_cell : Vector2i, end_cell : Vector2i) -> Vector2i:
	var key_cell = start_cell
	while key_cell == start_cell || key_cell == end_cell:
		key_cell = Vector2i(randi_range(0, maze_size.x - 1), randi_range(0, maze_size.y - 1))
	return key_cell
