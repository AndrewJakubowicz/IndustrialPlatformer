extends Node2D

onready var sound = [
$Hit1,
$Hit2]

func hit_sound():
	var s = sound[floor(rand_range(0, sound.size()))]
	s.play()