extends RigidBody3D

var speed: float = 10

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(global_transform.basis.x * speed * delta)
	if collision != null:
		queue_free()
