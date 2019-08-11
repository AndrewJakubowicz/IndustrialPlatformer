extends Node2D

onready var score = [
	$sound1,
	$sound2,
	$sound3,
	$sound4
]

func play_sound():
	var sound = score[floor(rand_range(0, score.size()))]
	sound.play()