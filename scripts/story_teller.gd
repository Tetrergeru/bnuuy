extends Node
class_name StoryTeller

var spawners: Array[SdiperSpawner] = []

var current_sdipers: int = 0

var waves = [
	[0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1],
	[0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 2],
	[0, 1, 2, 0, 1, 2, 0, 1, 0, 1, 0, 1, 1, 2],
]

@export var cooldown: float = 2.2
@export var total_sdipers: int = 10

func _ready() -> void:
	all_waves()

func all_waves():
	await wave(0)
	await get_tree().create_timer(3).timeout
	await wave(1)
	await get_tree().create_timer(3).timeout
	await wave(2)

func wave(wave_idx: int):
	while spawners.size() == 0:
		await get_tree().process_frame
		
	for sdiper in waves[wave_idx]:
		while total_sdipers < current_sdipers:
			await get_tree().process_frame
		spawn_sdiper(sdiper)
		await get_tree().create_timer(cooldown).timeout
		
	while current_sdipers != 0:
		await get_tree().process_frame
	print("wave finished")
	
	pass

func spawn_sdiper(idx: int):
	print("sdiper spawned")
	current_sdipers += 1
	spawners.pick_random().spawn_sdiper(idx)

func sdiper_killed():
	print("sdiper killed")
	current_sdipers -= 1
