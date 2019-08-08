extends Node2D

onready var sprite = $Sprite
onready var cooldown_timer = $Cooldown
onready var bounce_collider = $BounceHit



func _on_BounceHit_bounced_player():
	bounce_collider.monitoring = false
	bounce_collider.monitorable = false
	sprite.modulate = Color.black
	cooldown_timer.start()
	yield(cooldown_timer, "timeout")
	bounce_collider.monitoring = true
	bounce_collider.monitorable = true
	sprite.modulate = Color('#00ffff')
