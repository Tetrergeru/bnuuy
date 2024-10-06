extends Node

@onready var spawn_point: Node3D = $SpawnPoint
var sdiper_prefabs = [preload("res://prefabs/sdiper_0.tscn")]

@export var cooldown: float = 0.3
@export var total_sdipers: int = 1

var cooldown_timer : float = 0

func _process(delta: float) -> void:
	cooldown_timer = max(cooldown_timer - delta, 0)
	if cooldown_timer == 0 && total_sdipers > 0:
		total_sdipers -= 1
		cooldown_timer = cooldown
		
		var instance: Node3D = sdiper_prefabs[0].instantiate()
		instance.global_transform = spawn_point.global_transform
		get_tree().root.add_child(instance)
