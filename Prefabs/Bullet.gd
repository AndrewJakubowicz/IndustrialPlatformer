extends RigidBody2D

onready var g = weakref($"Ground detector/CollisionShape2D")
onready var t = $DestructionTimer
onready var bullet_collider = weakref($Bullet_shape)
onready var sprite = $Sprite


func _on_Ground_detector_body_entered(body):
	queue_free()

func _on_BounceHit_bounced_player():
	if g.get_ref():
		g.get_ref().queue_free()
	if bullet_collider.get_ref():
		bullet_collider.get_ref().queue_free()
	sprite.visible = false
	t.start(2)
	yield(t, "timeout")
	queue_free()
