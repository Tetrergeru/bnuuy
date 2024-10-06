extends Area3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@export var time_to_die: float = 1
@export var steps_to_die: int = 30
@export var max_scale: float = 1.5

var material: StandardMaterial3D

func _ready() -> void:
	connect("body_entered", _on_area_enter)
	material = mesh.get_surface_override_material(0)
	explosion()
	
func _on_area_enter(body):
	disable()
	if body.has_method("deal_damage"):
		body.deal_damage(1)
	
func disable():
	await get_tree().process_frame
	self.collision_mask = 0

func explosion():
	for i in steps_to_die:
		var a = 1.0 - (1.0 * i) / steps_to_die
		material.albedo_color.a = sqrt(a)
		var sc = (max_scale * i) / steps_to_die
		mesh.scale = Vector3(sc, sc, sc)
		await get_tree().create_timer(time_to_die / steps_to_die).timeout
	self.queue_free()

	
