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

onready var die = [
$Die1,
$Die2,
$Die3,
$Die4
]

onready var bump = [
$Bump1,
$Bump2,
$Bump3,
$Bump4,
$Bump5
]


onready var jump_air = [
$jump_air1,
$jump_air2,
$jump_air3,
$jump_air4
]

onready var jump_recharge = [
$jump_recharge1,
$jump_recharge2,
$jump_recharge3,
$jump_recharge4
]

onready var attack = [
$attack1,
$attack2]

onready var jump = $Jump

func play_footstep():
	var sound = footsteps[floor(rand_range(0, footsteps.size()))]
	sound.play()
	
func play_jump():
	play_footstep()
	
func play_die():
	var death_sound = die[floor(rand_range(0, die.size()))]
	var bump_sound = bump[floor(rand_range(0, bump.size()))]
	bump_sound.play()
	death_sound.play()

func play_jump_air():
	var sound = jump_air[floor(rand_range(0, jump_air.size()))]
	sound.play()

func play_jump_recharge():
	var sound = jump_recharge[floor(rand_range(0, jump_recharge.size()))]
	sound.play()

func play_attack():
	var sound = attack[floor(rand_range(0, attack.size()))]
	sound.play()