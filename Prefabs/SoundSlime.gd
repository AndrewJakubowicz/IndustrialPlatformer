extends Node2D

onready var hit = [
$Hurt1,
$Hurt2,
$Hurt3,
$Hurt4,
$Hurt5]

func play_hurt():
	var sound = hit[floor(rand_range(0, hit.size()))]
	sound.play()
