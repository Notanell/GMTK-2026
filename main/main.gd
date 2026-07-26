extends Node

@export var shift_time : float = 5

@onready var UI_MAIN = $CanvasLayer/ui_main

# Game Parameters
const maze_sizes : Array[Vector2i] = [Vector2i(8, 6), Vector2i(9, 9), Vector2i(11, 10), Vector2i(12, 12), Vector2i(13, 13), Vector2i(15, 15), Vector2i(18, 18)]
#const shift_times : PackedFloat32Array = [5, 5, 7, 9, 10, 10, 10]

var min_shift_time = 5.0
var max_shift_time = 20.0

# test Game Parameters
#const maze_sizes : Array[Vector2i] = [Vector2i(4, 4)]
#const shift_times : PackedFloat32Array = [120]

var current_maze_idx : int = 0
var completed_current : bool = false
var key_collected : bool = false
var start_cell = Vector2i(0, 0)
var end_cell = Vector2i(0, 0)
var key_cell = Vector2i(0, 0)

var startup = true

# Called when the node enters the scene tree for the first time.
func _ready():
	start_cell = Vector2i(0, 0)
	#end_cell = maze_sizes[current_maze_idx] - Vector2i(1, 1)
	var arrayreturn = $Maze.new_maze(maze_sizes[current_maze_idx], start_cell)
	end_cell = arrayreturn[0]
	key_cell = arrayreturn[1]
	inject_mazeinfotoplayer()
	UI_MAIN.get_node("CountToExit/CountToExit_Label").set_text("Distance To Key")
	UI_MAIN.get_node("Lock").set_frame(0)
	$Player.set_maze_pos(start_cell)
	$ShiftTimer.start(select_shift_time($Maze.currentdistance_fromtarget($Player.maze_coord, key_cell)))
	$Fog.inner_diam = $Fog.main_diam
	var tween = get_tree().create_tween()
	tween.tween_property($Fog, "inner_diam", $Fog.default_inner_diam, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_delay(2.0)
	get_tree().root.get_node("/root/GlobalUI").toggle_pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Fog.global_position = $Player.global_position
	if $Maze.maze_ready == true: # if the maze is ready to be moved around in, do all the processing involved in the player moving around
		var dist_from_target := 0
		if key_collected == false:
			dist_from_target = $Maze.currentdistance_fromtarget($Player.maze_coord, key_cell)
		else:
			dist_from_target = $Maze.currentdistance_fromtarget($Player.maze_coord, end_cell)
		UI_MAIN.set_counttoexit(dist_from_target)
		var time_left = $ShiftTimer.get_time_left()
		if time_left < 1.0 && $MazeChanging.playing == false && completed_current == false:
			$MazeChanging.playing = true
		UI_MAIN.set_counttoshift(time_left)
		if dist_from_target == 0 && completed_current == false: # if we've reached the target and not completed the current maze
			if key_collected: # if we've got the key, move to the next maze
				$Player.can_move = false
				$ShiftTimer.stop()
				completed_current = true
				var tween = get_tree().create_tween()
				tween.tween_property($Fog, "inner_diam", $Fog.main_diam, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
				if current_maze_idx != (maze_sizes.size() - 1):
					tween.tween_callback(fog_away_complete)
				else: # if all the mazes are finished, go to scene change callback
					tween.tween_callback(fog_end_complete)
			else: # if we don't have the key, collect it and change the distance counter to the exit distance
				key_collected = true
				$Maze.erase_overlay_cell(key_cell)
				UI_MAIN.get_node("CountToExit/CountToExit_Label").set_text("Distance To Exit")
				UI_MAIN.get_node("Lock").set_frame(1)
				$KeyCollect.play()
	else:
		$Player.can_move = false

func inject_mazeinfotoplayer():
	$Player.tilemap = $Maze/TileMapLayer
	$Player.maze = $Maze.maze
	$Player.maze_size = $Maze.maze_size
	$Player.maze_tileoffset = $Maze.maze_tileoffset

func increment_maze(): # moves to the next maze size
	current_maze_idx += 1
	start_cell = end_cell
	var arrayreturn = $Maze.new_maze(maze_sizes[current_maze_idx], start_cell)
	end_cell = arrayreturn[0]
	key_cell = arrayreturn[1]
	inject_mazeinfotoplayer()
	UI_MAIN.get_node("Lock").set_frame(0)
	UI_MAIN.get_node("CountToExit/CountToExit_Label").set_text("Distance To Key")
	$ShiftTimer.start(select_shift_time($Maze.currentdistance_fromtarget($Player.maze_coord, end_cell)))
	completed_current = false
	key_collected = false
	
func _on_timer_timeout(): # generates a new maze of the same size, with the same end point and key cell
	$Player.can_move = false
	$Maze.new_maze(maze_sizes[current_maze_idx], start_cell, end_cell, key_cell)
	if key_collected: 
		$Maze.erase_overlay_cell(key_cell)
	inject_mazeinfotoplayer()
	$ShiftTimer.start(select_shift_time($Maze.currentdistance_fromtarget($Player.maze_coord, end_cell)))
	$Player.can_move = true

func fog_away_complete():
	increment_maze()
	var tween = get_tree().create_tween()
	tween.tween_property($Fog, "inner_diam", $Fog.default_inner_diam, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_delay(1.0)
	$Player.can_move = true

func fog_end_complete():
	SceneManager.load_scene("end")
	
func select_shift_time(path_length) -> float:
	var time = pow(path_length, 0.65)
	time = ceil(clamp(time, min_shift_time, max_shift_time))
	return time
