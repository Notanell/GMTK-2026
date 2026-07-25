extends Node2D

const main_diam := 1200.0
const default_inner_diam := 300.0
const starting_inner_diam := 0.0

var width = 2 * (main_diam - starting_inner_diam / 2)

var inner_diam = default_inner_diam:
	set(input):
		width = 2 * (main_diam - input / 2)
		queue_redraw()
	get():
		return 2 * (main_diam - width / 2)

func _draw():
	draw_circle(Vector2(0, 0), main_diam, Color.BLACK, false, width, true)
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
