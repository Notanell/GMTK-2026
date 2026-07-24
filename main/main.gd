extends Node

#@export var maze_size = Vector2i(18, 15)
@export var shift_time : float = 5

const maze_sizes : Array[Vector2i] = [Vector2i(5, 5), Vector2i(7, 7), Vector2i(9, 9), Vector2i(11, 10), Vector2i(13, 11), Vector2i(15, 13), Vector2i(18, 15)]
var current_maze_size : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Maze.new_maze(maze_sizes[current_maze_size])
	inject_mazeinfotoplayer()
	$Player.start(Vector2(60, 60))
	$ShiftTimer.start(shift_time)
	#print($Maze.currentdistance_fromend($Player.maze_coord))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Maze.currentdistance_fromend($Player.maze_coord))
	var dist_from_end = $Maze.currentdistance_fromend($Player.maze_coord)
	$ui_main.set_counttoexit(dist_from_end)
	$ui_main.set_counttoshift($ShiftTimer.get_time_left())
	if dist_from_end == 0:
		increment_maze()
	pass

func inject_mazeinfotoplayer():
	$Player.tilemap = $Maze/TileMapLayer
	$Player.maze = $Maze.maze
	$Player.maze_size = $Maze.maze_size
	$Player.maze_tileoffset = $Maze.maze_tileoffset

func increment_maze():
	current_maze_size += 1
	$Maze.new_maze(maze_sizes[current_maze_size])
	inject_mazeinfotoplayer()
	$Player.start(Vector2(60, 60))
	$ShiftTimer.start(shift_time)
	
func _on_timer_timeout():
	$Maze.new_maze(maze_sizes[current_maze_size])
	inject_mazeinfotoplayer()
	$ShiftTimer.start(shift_time)
	pass # Replace with function body.
