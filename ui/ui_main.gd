extends Control
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_counttoexit(count : int):
	$CountToExit/CountToExit_Count.set_text(String.num_int64(count))
