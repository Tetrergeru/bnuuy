extends Node

@onready var bnuuy: Node3D = $bnuuy

var game_scene = preload("res://scenes/main.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	bnuuy.rotate_y(delta)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
