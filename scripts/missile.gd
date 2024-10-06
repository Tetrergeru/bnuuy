extends RigidBody3D

var speed: float = 10

@onready var carrot: Node3D = $Carrot2 

var expolosion = preload("res://prefabs/explosion.tscn")

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(global_transform.basis.x * speed * delta)
	var velocity = linear_velocity + global_transform.basis.x * speed
	carrot.global_transform = carrot.global_transform.looking_at(global_position + velocity)
	if collision != null:
		self.collision_mask = 0
		var instance: Node3D = expolosion.instantiate()
		instance.global_transform = global_transform
		get_parent().add_child(instance)
		die_in_secs(2.0)

func die_in_secs(secs: float):
	await get_tree().create_timer(secs).timeout
	self.queue_free()
