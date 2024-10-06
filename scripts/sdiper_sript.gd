extends CharacterBody3D
class_name SdiperController

var player_controller: PlayerController

@export var speed: float = 1
@export var health: float = 1
@export var atack_timeout: float = 1
@export var distance: float = 1

var atack_timer = 0

@onready var state_machine: AnimationNodeStateMachinePlayback = $sdiper/AnimationTree.get("parameters/playback")
@onready var area: ShapeCast3D = $sdiper/WhistleArmature/Skeleton3D/TargetAtachment/ShapeCast3D

func _ready() -> void:
	#area.connect("body_entered", _on_body_enter)
	pass

func _physics_process(delta: float):
	atack_timer = max(atack_timer - delta, 0)
	
	if !player_controller:
		player_controller = find_player(get_tree().root)
		
	if !player_controller:
		return
	
	var player_pos = player_controller.global_position
	var self_pos = global_position
	
	if (player_pos - self_pos).length() < 1 && atack_timer == 0:
		atack_timer = atack_timeout
		atack()
	
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

func atack():
	state_machine.travel("AtackBlend")
	for i in area.get_collision_count():
		var col = area.get_collider(i)
		if col is PlayerController:
			col.handle_damage(1)
			return

func deal_damage(damage: float):
	health -= damage
	if (health <= 0):
		queue_free()
