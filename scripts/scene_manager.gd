extends Node

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")
const MAIN = preload("res://main/main.tscn")
const END = preload("res://end_scene/end_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_mainmenu():
	get_tree().change_scene_to_packed(MAIN_MENU)

func load_main():
	get_tree().change_scene_to_packed(MAIN)

func load_end():
	get_tree().change_scene_to_packed(END)
