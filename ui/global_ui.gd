extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseMenu.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	pass

func toggle_pause():
	get_tree().paused = !get_tree().paused
	$PauseMenu.visible = get_tree().paused
