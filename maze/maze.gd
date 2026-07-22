extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_tile(pos):
	$TileMapLayer.set_cell(pos, 0, Vector2i(1, 0))
