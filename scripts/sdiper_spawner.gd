extends Node
class_name SdiperSpawner

@onready var spawn_point: Node3D = $SpawnPoint
var sdiper_prefabs = [preload("res://prefabs/sdiper_0.tscn"), preload("res://prefabs/sdiper_1.tscn"), preload("res://prefabs/sdiper_2.tscn")]

var player: PlayerController
var storyteller: StoryTeller

func _process(delta: float) -> void:
	if !player:
		player = find_player(get_tree().root)
	
	if !storyteller:
		storyteller = find_storyteller(get_tree().root)
		if storyteller:
			storyteller.spawners.push_back(self)
		
	if !player || !storyteller:
		return
	

func spawn_sdiper(idx: int):
	var instance: SdiperController = sdiper_prefabs[idx].instantiate()
	var scale = instance.scale
	instance.scale = scale
	instance.player_controller = player
	instance.spawner = self
	get_parent().add_child(instance)
	instance.global_position = spawn_point.global_position

func find_player(node) -> PlayerController:
	for ch in node.get_children(true):
		if ch is PlayerController:
			return ch
		else:
			var found = find_player(ch)
			if found:
				return found
	return null

func find_storyteller(node) -> StoryTeller:
	for ch in node.get_children(true):
		if ch is StoryTeller:
			return ch
		else:
			var found = find_storyteller(ch)
			if found:
				return found
	return null
	
func sdiper_killed():
	storyteller.sdiper_killed()
