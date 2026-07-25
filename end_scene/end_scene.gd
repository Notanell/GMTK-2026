extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fog.inner_diam = 0
	$Fog.global_position = get_viewport_rect().size / 2
	var tween = get_tree().create_tween()
	tween.tween_property($Fog, "inner_diam", $Fog.main_diam, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_delay(0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	SceneManager.load_scene("main_menu")
	pass # Replace with function body.
