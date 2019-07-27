extends KinematicBody2D

var GRAVITY = 200
var max_movement = 100

func _on_Area2D_body_entered(body):
	if body.has_method("player_hit"):
		body.player_hit(1)
