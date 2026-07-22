extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start(Vector2(100, 100))
	$Maze.place_tile(Vector2(2, 2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
