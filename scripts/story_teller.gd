extends Node
class_name StoryTeller

var spawners: Array[SdiperSpawner] = []

var current_sdipers: int = 0

var waves = [
	[0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1],
	[0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 2],
	[0, 1, 2, 0, 1, 2, 0, 1, 0, 1, 0, 1, 1, 2],
]

#var waves = [
	#[0],
	#[0],
	#[0], 
#]

@export var cooldown: float = 2.2
@export var total_sdipers: int = 10

@onready var lines: Array[AudioStreamPlayer] = [
	$Line0,
	$Line1,
	$Line2,
	$Line3,  
	$LineLoose,  
]

@onready var subtitles: RichTextLabel = $Subtitles

var lines_text : Array[String] = [
	"Private Bnuuy, you are deployed aganst evil sdipers! You must overcome three waves of them.",
	"Great job, private Bnuuy! Only two waves to go.",
	"Your skills are unmatched, private Bnuuy, but the final wave is by far the strongest one.",
	"Unbelivable! Bnuuy, you did it! Our team is forever grateful, come back to the base for your carrot pie.",
	"Don't lose your heart, Bnuuy. We will resore your cyber body and you may try again.",
]

var player: PlayerController

func _process(delta: float) -> void:
	if !player:
		return
		
	if player.health <= 0:
		death()

func death():
	var camera_pole: Node3D  = player.get_node("CameraPole")
	var transform = camera_pole.global_transform
	player.remove_child(camera_pole)
	add_child(camera_pole)
	camera_pole.global_transform = transform
	player.queue_free()
	await play_audio(4)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready() -> void:
	all_waves()

func all_waves():
	print(lines)
	await play_audio(0)
	
	while spawners.size() == 0:
		await get_tree().process_frame
	player = spawners[0].player
	
	await wave(0)
	await play_audio(1)
	
	await get_tree().create_timer(3).timeout
	await wave(1)
	await play_audio(2)
	
	await get_tree().create_timer(3).timeout
	await wave(2)
	await play_audio(3)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func wave(wave_idx: int):
	for sdiper in waves[wave_idx]:
		while total_sdipers < current_sdipers:
			await get_tree().process_frame
		spawn_sdiper(sdiper)
		await get_tree().create_timer(cooldown).timeout
		
	while current_sdipers != 0:
		await get_tree().process_frame
	print("wave finished")

func play_audio(idx: int):
	subtitles.text = "[center]Captain Bnuny: " + lines_text[idx] + "[/center]"
	var stream = lines[idx]
	stream.play()
	while stream.playing:
		await get_tree().process_frame
	subtitles.text = ""

func spawn_sdiper(idx: int):
	print("sdiper spawned")
	current_sdipers += 1
	spawners.pick_random().spawn_sdiper(idx)

func sdiper_killed():
	print("sdiper killed")
	current_sdipers -= 1
