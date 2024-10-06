extends Node3D

@export var target: Node3D

func _process(_delta: float) -> void:
	if !target:
		return
	global_transform = target.global_transform
