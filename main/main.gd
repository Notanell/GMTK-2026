extends Node

@export var maze_size = Vector2i(18, 15)
@export var shift_time : float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Maze.new_maze(maze_size)
	inject_mazeinfotoplayer()
	$Player.start(Vector2(60, 60))
	$ShiftTimer.start(shift_time)
	#print($Maze.currentdistance_fromend($Player.maze_coord))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Maze.currentdistance_fromend($Player.maze_coord))
	$ui_main.set_counttoexit($Maze.currentdistance_fromend($Player.maze_coord))
	$ui_main.set_counttoshift($ShiftTimer.get_time_left())
	pass

func inject_mazeinfotoplayer():
	$Player.tilemap = $Maze/TileMapLayer
	$Player.maze = $Maze.maze
	$Player.maze_size = $Maze.maze_size
	$Player.maze_tileoffset = $Maze.maze_tileoffset
	

func _on_timer_timeout():
	$Maze.new_maze(maze_size)
	inject_mazeinfotoplayer()
	$ShiftTimer.start(shift_time)
	pass # Replace with function body.
