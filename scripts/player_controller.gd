extends CharacterBody3D
class_name PlayerController

@export var max_up_rotation_angle: float = 30
@export var max_down_rotation_angle: float = 45
@export var sensitivity: float = 0.01;
@export var jump_velocity: Vector3 = Vector3(5, 10, 0);
@export var kickback: float = 5

var missile = preload("res://prefabs/missile.tscn")

@onready var camera_pole: Node3D = $CameraPole
@onready var gun: Node3D = $bnuuy/Gun
@onready var jump_sound: AudioStreamPlayer3D = $bnuuy/JumpSound
@onready var landing_sound: AudioStreamPlayer3D = $bnuuy/LandingSound
@onready var spawn_points: Array[Node3D] = [$bnuuy/Gun/SpawnPoint1,  $bnuuy/Gun/SpawnPoint2]
var current_point: int = 0
@onready var state_machine: AnimationNodeStateMachinePlayback = $bnuuy/AnimationTree.get("parameters/playback")

@onready var hearts: HBoxContainer = $Hearts
var heart = preload("res://prefabs/heart_ui.tscn")
var health: int = 1

var jump_timer: float = 0
var is_jumping = true
@export var fire_timeout = 0.2
var fire_timer: float = 0

@export var restart_position: Node3D

func _ready() -> void:
	update_hearts()

func _process(delta: float) -> void:
	fire_timer = max(fire_timer - delta, 0)
	
	if global_position.y < -5:
		self.global_transform = restart_position.global_transform
	
	if Input.is_action_just_pressed("Esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("fire") && fire_timer <= 0:
		fire_timer = fire_timeout
		var instance: Node3D = missile.instantiate()
		instance.global_transform = spawn_points[current_point].global_transform
		instance.rotation.z = camera_pole.rotation.z
		current_point = (current_point + 1) % 2
		get_parent().add_child(instance)
		velocity += -instance.global_transform.basis.x * kickback

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		handle_rotate(event.relative * sensitivity)
	elif event is InputEventMouseButton && Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float):
	jump_timer = max(jump_timer - delta, 0)
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		if is_jumping:
			landing_sound.play()
			is_jumping = false
		if jump_timer <= 0:
			velocity.x = 0
			velocity.z = 0
			if Input.is_action_pressed("jump"):
				handle_jump()
			
	move_and_slide()

func handle_rotate(shift: Vector2):
	camera_pole.rotate_y(-shift.x)
	gun.rotation.y = camera_pole.rotation.y
	camera_pole.rotation.z = clampf(
		camera_pole.rotation.z - shift.y,
		-deg_to_rad(max_down_rotation_angle),
		deg_to_rad(max_up_rotation_angle),
	)
	
func handle_jump():
	is_jumping = true
	jump_sound.play()
	state_machine.travel("Jump")
	jump_timer = 0.1
	var rot_y = camera_pole.global_rotation.y
	global_rotation.y = rot_y
	camera_pole.rotation.y = 0
	gun.rotation.y = 0
	velocity = jump_velocity.rotated(Vector3.UP, rot_y)

func handle_damage(damage: int):
	health -= damage
	update_hearts()

func heal(heal: int):
	health += heal
	update_hearts()

func update_hearts():
	if health <= 0:
		health = 0
		return
	var children = hearts.get_children()
	if children.size() > health:
		for i in children.size() - health:
			hearts.remove_child(children[i])
	if children.size() < health:
		for i in health - children.size():
			var new_heart = heart.instantiate()
			hearts.add_child(new_heart)
