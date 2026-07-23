extends Node2D

var MazeGenerator = MazeGen.new()

var maze_size = Vector2i(10, 10)

# Called when the node enters the scene tree for the first time.
func _ready():
	var maze = MazeGenerator.generate_maze(maze_size)
	for y in range(maze_size.y):
		print(maze.slice(0 + (y * maze_size.x), (maze_size.x) + (y * maze_size.x)))
		for x in range(maze_size.x):
			var cell = maze[x + y * maze_size.x]
			place_tile(Vector2i(x, y), cell)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_tile(pos: Vector2i, cell : int):
	print(cell & 0b0101)
	if (cell & 0b0101) == 0b0101:
		$TileMapLayer.set_cell(pos, 0, Vector2i(1, 0))
