extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Maze.new_maze(Vector2i(18, 16))
	inject_mazeinfotoplayer()
	$Player.start(Vector2(60, 60))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func inject_mazeinfotoplayer():
	$Player.tilemap = $Maze/TileMapLayer
	$Player.maze = $Maze.maze
	$Player.maze_size = $Maze.maze_size
	$Player.maze_tileoffset = $Maze.maze_tileoffset
