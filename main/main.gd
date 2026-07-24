extends Node

@export var shift_time : float = 5

const maze_sizes : Array[Vector2i] = [Vector2i(5, 5), Vector2i(7, 7), Vector2i(9, 9), Vector2i(11, 10), Vector2i(13, 11), Vector2i(15, 13), Vector2i(18, 15)]
var current_maze_idx : int = 0
var completed_current : bool = false
var start_cell = Vector2i(0, 0)
var end_cell = Vector2i(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_cell = Vector2i(0, 0)
	#end_cell = maze_sizes[current_maze_idx] - Vector2i(1, 1)
	end_cell = $Maze.new_maze(maze_sizes[current_maze_idx], start_cell)
	inject_mazeinfotoplayer()
	$Player.set_maze_pos(start_cell)
	$ShiftTimer.start(shift_time)
	var tween = get_tree().create_tween()
	tween.tween_property($Fog, "inner_diam", $Fog.default_inner_diam, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Fog.global_position = $Player.global_position
	if $Maze.maze_ready == true:
		var dist_from_end = $Maze.currentdistance_fromend($Player.maze_coord)
		$ui_main.set_counttoexit(dist_from_end)
		$ui_main.set_counttoshift($ShiftTimer.get_time_left())
		if dist_from_end == 0 && completed_current == false:
			$Player.can_move = false
			$ShiftTimer.stop()
			completed_current = true
			if current_maze_idx != (maze_sizes.size() - 1):
				var tween = get_tree().create_tween()
				tween.tween_property($Fog, "inner_diam", $Fog.main_diam, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
				tween.tween_callback(fog_away_complete)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property($Fog, "inner_diam", 0, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
				tween.tween_callback(fog_end_complete)
		pass
	else:
		$Player.can_move = false

func inject_mazeinfotoplayer():
	$Player.tilemap = $Maze/TileMapLayer
	$Player.maze = $Maze.maze
	$Player.maze_size = $Maze.maze_size
	$Player.maze_tileoffset = $Maze.maze_tileoffset

func increment_maze():
	current_maze_idx += 1
	start_cell = end_cell
	#end_cell = maze_sizes[current_maze_idx] - Vector2i(1, 1)
	#end_cell = $Maze.select_end_cell()
	end_cell = $Maze.new_maze(maze_sizes[current_maze_idx], start_cell)
	inject_mazeinfotoplayer()
	#$Player.start(Vector2(60, 60))
	$ShiftTimer.start(shift_time)
	
func _on_timer_timeout():
	$Player.can_move = false
	$Maze.new_maze(maze_sizes[current_maze_idx], start_cell, end_cell)
	inject_mazeinfotoplayer()
	$ShiftTimer.start(shift_time)
	$Player.can_move = true
	pass # Replace with function body.

func fog_away_complete():
	increment_maze()
	var tween = get_tree().create_tween()
	tween.tween_property($Fog, "inner_diam", $Fog.default_inner_diam, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	completed_current = false
	$Player.can_move = true

func fog_end_complete():
	SceneManager.load_end()
