extends Area2D

export (float) var damage = 1

func _on_Spike_body_entered(body):
	if body.has_method("player_hit"):
		body.player_hit(damage)
