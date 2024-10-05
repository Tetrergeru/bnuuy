extends CharacterBody3D

@export var max_up_rotation_angle: float = 30
@export var max_down_rotation_angle: float = 45
@export var sensitivity: float = 0.01;
@export var jump_velocity: Vector3 = Vector3(5, 10, 0);

var missile = preload("res://prefabs/missile.tscn")

@onready var camera_pole: Node3D = $CameraPole
@onready var gun: Node3D = $bnuuy/Gun
@onready var spawn_point_1: Node3D = $bnuuy/Gun/SpawnPoint1
@onready var state_machine: AnimationNodeStateMachinePlayback = $bnuuy/AnimationTree.get("parameters/playback")

var jump_timer: float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		var instance: Node3D = missile.instantiate()
		#instance.global_rotation = spawn_point_1.global_rotation
		#instance.global_position = spawn_point_1.global_position
		instance.global_transform = spawn_point_1.global_transform
		get_tree().root.add_child(instance)

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
		if jump_timer <= 0:
			velocity.x = 0
			velocity.z = 0
		if Input.is_action_just_pressed("jump"):
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
	state_machine.travel("Jump")
	jump_timer = 0.1
	var rot_y = camera_pole.global_rotation.y
	global_rotation.y = rot_y
	camera_pole.rotation.y = 0
	gun.rotation.y = 0
	velocity = jump_velocity.rotated(Vector3.UP, rot_y)
