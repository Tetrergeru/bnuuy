extends Node

@onready var spawn_point: Node3D = $SpawnPoint
var sdiper_prefabs = [preload("res://prefabs/sdiper_0.tscn"), preload("res://prefabs/sdiper_1.tscn"), preload("res://prefabs/sdiper_2.tscn")]

@export var cooldown: float = 2
@export var total_sdipers: int = 10

var cooldown_timer : float = 0

func _process(delta: float) -> void:
	cooldown_timer = max(cooldown_timer - delta, 0)
	if cooldown_timer == 0 && total_sdipers > 0:
		total_sdipers -= 1
		cooldown_timer = cooldown
		
		var instance: Node3D = sdiper_prefabs.pick_random().instantiate()
		var scale = instance.scale
		instance.scale = scale
		get_tree().root.add_child(instance)
		instance.global_position = spawn_point.global_position
