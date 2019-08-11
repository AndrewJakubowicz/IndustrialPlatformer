extends Node2D

onready var footsteps = [
$Footstep1,
$Footstep2,
$Footstep3,
$Footstep4,
$Footstep5,
$Footstep6,
$Footstep7,
$Footstep8,
$Footstep9,
$Footstep10
]

onready var jump = $Jump

func play_footstep():
	var sound = footsteps[floor(rand_range(0, footsteps.size()))]
	sound.play()
	
func play_jump():
	play_footstep()