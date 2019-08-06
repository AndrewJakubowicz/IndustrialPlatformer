extends Area2D

signal bounced_player

## Add this node to anything you want the player to be able to bounce off

onready var timer = $Timer

func _on_BounceHit_area_entered(area):
	emit_signal("bounced_player")
	get_tree().call_group("reset_jump", "reset_jump")
	get_tree().call_group("freeze", "freeze")
	timer.start(0.15)
	yield(timer, "timeout")
	get_tree().call_group("freeze", "unfreeze")

