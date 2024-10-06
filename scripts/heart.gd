extends Area3D
class_name Heart

var stump: Stump

func _ready() -> void:
	print("Spawn", stump)
	connect("body_entered", _on_collision)

func _on_collision(body):
	if body is not PlayerController:
		return
		
	body.heal(3)
	queue_free()
	if stump != null:
		stump.heart_taken()
