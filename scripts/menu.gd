extends Node

@onready var bnuuy: Node3D = $bnuuy
@onready var slider: HSlider = $TextureRect/HSlider

var game_scene = preload("res://scenes/main.tscn")
var music_prefab = preload("res://scenes/music.tscn")

var _sounds_bus_index: int
var music: MusicToken

func _init():
	_sounds_bus_index = AudioServer.get_bus_index("Music")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	music = find_music(get_tree().root)
	if !music:
		var instance = music_prefab.instantiate()
		get_tree().root.add_child.call_deferred(instance)
		slider.value = 2
	else:
		slider.value = music.value

func _process(delta: float) -> void:
	bnuuy.rotate_y(delta)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func find_music(node) -> MusicToken:
	for ch in node.get_children(true):
		if ch is MusicToken:
			return ch
		else:
			var found = find_music(ch)
			if found:
				return found
	return null


func _on_h_slider_value_changed(value: float) -> void:
	if music:
		music.value = value
	print(value)
	AudioServer.set_bus_volume_db(_sounds_bus_index, linear_to_db(value / 10))
