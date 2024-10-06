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
@onready var launcher: Node3D = $MissleLauncher

@export var missile_timeout: float = 3
var missile_timer: float = 3
var homing_missile = preload("res://prefabs/homing_missile.tscn")  

var spawner: SdiperSpawner

func _physics_process(delta: float):
	if !player_controller:
		return
	
	if global_position.y < -10:
		deal_damage(1000)
		
	atack_timer = max(atack_timer - delta, 0)
	missile_timer = max(missile_timer - delta, 0)
	
	if missile_timer == 0:
		missile_timer = missile_timeout
		var instance: HomingMissile = homing_missile.instantiate()
		instance.player = player_controller
		instance.global_transform = launcher.global_transform
		get_parent().add_child(instance)
	
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
		spawner.sdiper_killed()
		queue_free()
