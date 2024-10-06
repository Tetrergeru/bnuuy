extends CharacterBody3D
class_name SdiperController

var player_controller: PlayerController

@export var speed: float = 1
@export var health: float = 1

func _ready() -> void:
	pass

func _physics_process(delta: float):
	if !player_controller:
		player_controller = find_player(get_tree().root)
		
	if !player_controller:
		return
	
	var player_pos = player_controller.global_position
	var self_pos = global_position
	
	var direction = (Vector2(player_pos.x, player_pos.z) - Vector2(self_pos.x, self_pos.z)).normalized()
	global_rotation.y = atan2(direction.x, direction.y)
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	
	move_and_slide()
	
func find_player(node) -> PlayerController:
	for ch in node.get_children(true):
		if ch is PlayerController:
			return ch
		else:
			var found = find_player(ch)
			if found:
				return found
	return null

func deal_damage(damage: float):
	health -= damage
	if (health <= 0):
		queue_free()
