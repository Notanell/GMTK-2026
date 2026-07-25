extends Node

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")
const MAIN = preload("res://main/main.tscn")
const END = preload("res://end_scene/end_scene.tscn")
#const TRANSITION = preload("res://fog/scene_transition_fog.tscn")

@onready var fog = get_tree().root.get_node("GlobalUI/Fog")
@onready var globalmusic_eerie = get_tree().root.get_node("AudioManager/EerieMusicGlobal")

var target_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", fog.main_diam, 1.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_scene(scene_name : String):
	target_scene = scene_name
	fade_fog_out()
	if target_scene == "main_menu":
		fade_in_music()
	elif target_scene == "end":
		fade_out_music()
	
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
	fade_fog_in()
	
func fade_fog_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", 0.0, 1.5)
	tween.tween_callback(finish_loading)
	
func fade_fog_in():
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "inner_diam", fog.main_diam, 1.5)
	
func fade_in_music():
	globalmusic_eerie.set_volume_linear(0)
	globalmusic_eerie.play()
	var tween = get_tree().create_tween()
	tween.tween_property(globalmusic_eerie, "volume_linear", 1, 5)

func fade_out_music():
	var tween = get_tree().create_tween()
	tween.tween_property(globalmusic_eerie, "volume_linear", 0, 5)
	tween.tween_callback(globalmusic_eerie.stop)
