extends RigidBody3D
class_name HomingMissile

var expolosion = preload("res://prefabs/homing_explosion.tscn")

@export var speed: float = 5
@export var time_to_seek: float = 1
@export var max_angle_degrees: float = 5

@onready var max_angle =  max_angle_degrees * PI / 180
@onready var mesh: Node3D = $Missile2/MeshInstance3D
@onready var shape: Node3D = $CollisionShape3D

var player: PlayerController
var disabled = false

func _physics_process(delta: float) -> void:
	if disabled:
		return
		
	time_to_seek = max(time_to_seek - delta, 0)
	if player && time_to_seek > 0:
		var pos = global_position
		var player_pos = player.global_position
		var desired_dir = (player_pos - pos).normalized()
		var dir = global_transform.basis.x
		var axis = desired_dir.cross(dir).normalized()
		var angle = acos(desired_dir.dot(dir))
		
		angle = clampf(angle, -max_angle, max_angle)
		global_rotate(axis, -angle)
		
	var collision = move_and_collide(global_transform.basis.x * speed * delta)
	if collision != null:
		mesh.queue_free()
		disabled = true
		self.collision_mask = 0
		shape.queue_free()
		var instance: Node3D = expolosion.instantiate()
		instance.global_transform = global_transform
		get_parent().add_child(instance)
		die_in_secs(2.0)

func die_in_secs(secs: float):
	await get_tree().create_timer(secs).timeout
	self.queue_free()
