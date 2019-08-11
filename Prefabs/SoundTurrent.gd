extends Node2D

onready var sounds = [
$Shot1,
$Shot2,
$Shot3,
$Shot4,
$Shot5,
$Shot6
]

func play_shot():
	var sound = sounds[floor(rand_range(0, sounds.size()))]
	sound.play()
