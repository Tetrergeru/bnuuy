extends Node
class_name MusicToken

@onready var music = $AudioStreamPlayer
var value: float = 2

func _process(delta: float) -> void:
	if !music.playing:
		music.play()
