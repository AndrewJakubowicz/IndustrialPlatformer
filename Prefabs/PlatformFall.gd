extends Node2D

export (bool) var start_raised = true
var position_up = not start_raised

onready var animationPlayer = $AnimationPlayer
onready var staticBody = $KinematicBody/CollisionShape2D

func _ready():
	position_up = not start_raised
	set_process(false)
	set_physics_process(false)
	toggle()


func toggle():
	if animationPlayer.is_playing():
		return
	position_up = not position_up
	
	if position_up:
		animationPlayer.play("raise")
		call_deferred('handleRaise')
	else:
		animationPlayer.play_backwards("raise")
		call_deferred('dropped')

func handleRaise():
	staticBody.disabled = false


func dropped():
	staticBody.disabled = true
