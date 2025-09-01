extends Node

const CASH = preload("res://Sound/cash.mp3")
const BUTTON = preload("res://Sound/click.mp3")

@onready var audioPlayers: = $AudioPlayers


#func _ready():
	#set_volume_db(0.2)

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			audioStreamPlayer.set_volume_db(-15)
			break
