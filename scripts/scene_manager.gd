extends Node

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")
const MAIN = preload("res://main/main.tscn")
const END = preload("res://end_scene/end_scene.tscn")
#const TRANSITION = preload("res://fog/scene_transition_fog.tscn")

@onready var fog_blackout = get_tree().root.get_node("SceneTransitionFog/FogBlackout")
@onready var fog = get_tree().root.get_node("SceneTransitionFog/Fog")

var target_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	fog_blackout.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", fog.main_diam, 1.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_scene(scene_name : String):
	target_scene = scene_name
	fade_out()
	
func finish_loading():
	if target_scene == "main_menu":
		get_tree().change_scene_to_packed(MAIN_MENU)
	elif target_scene == "main":
		get_tree().change_scene_to_packed(MAIN)
	elif target_scene == "end":
		get_tree().change_scene_to_packed(END)
	else:
		get_tree().change_scene_to_packed(MAIN_MENU) # default to main menu
	await get_tree().scene_changed
	fade_in()
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", 0.0, 1.5)
	tween.tween_callback(finish_loading)
	
func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", fog.main_diam, 1.5)
		
#func load_mainmenu():
	#get_tree().change_scene_to_packed(MAIN_MENU)

#func load_main():
	#var tween = get_tree().create_tween()
	#tween.tween_property(fog, "inner_diam", 0.0, 1.5)
	#tween.tween_callback(finish_main_loading)
	

#func load_end():
	#get_tree().change_scene_to_packed(END)
