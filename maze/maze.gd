extends Node2D

const maze_maxsize = Vector2i(18, 15)

var MazeGenerator = MazeGen.new()
var maze_size = Vector2i(18, 15)
var maze_tileoffset = Vector2i(1, 1)
var maze : PackedInt32Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_maze(maze_size_input):
	maze_size = maze_size_input
	if maze_size.x > maze_maxsize.x:
		maze_size.x = maze_maxsize.x
	if maze_size.y > maze_maxsize.y:
		maze_size.y = maze_maxsize.y
	
	maze = MazeGenerator.generate_maze(maze_size)
	for y in range(maze_size.y):
		#print(String.num_int64(maze.slice(0 + (y * maze_size.x), (maze_size.x) + (y * maze_size.x))), 2)
		var printstring : String = ''
		for x in range(maze_size.x):
			var num_str = String.num_int64(maze[x + (y * maze_size.x)], 2)
			printstring += num_str.pad_zeros(4)
			printstring += ', '
			var cell = maze[x + (y * maze_size.x)]
			place_tile(Vector2i(x, y), cell)
		print(printstring)

func place_tile(pos: Vector2i, cell : int):
	if ((cell & MazeHelp.startend_mask) == MazeHelp.tiletype_binary['START']):
		$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord['START'])
		return
	elif ((cell & MazeHelp.startend_mask) == MazeHelp.tiletype_binary['END']):
		$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord['END'])
		return
	for key in MazeHelp.tiletype_binary.keys():
		if (cell & MazeHelp.connect_mask) == MazeHelp.tiletype_binary[key]:
			#print(key)
			$TileMapLayer.set_cell(pos + maze_tileoffset, 0, MazeHelp.tiletype_atlascoord[key])
			break
		
