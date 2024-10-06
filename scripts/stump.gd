extends Node
class_name Stump

@export var timeout: float = 15
var timer = 0

@onready var spawn: Node3D = $HeartSpawnPoint 
@onready var powerup_sound: AudioStreamPlayer3D = $PowerupSound 
var heart: Heart

var prefab = preload("res://prefabs/heart.tscn")

func heart_taken():
	powerup_sound.play()
	heart = null
	timer = timeout

func _process(delta: float) -> void:
	timer = max(0, timer - delta)
	if timer <= 0 && heart == null:
		heart = prefab.instantiate()
		heart.stump = self
		get_parent().add_child(heart)
		heart.global_position = spawn.global_position
