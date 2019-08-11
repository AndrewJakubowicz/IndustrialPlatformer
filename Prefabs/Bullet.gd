extends RigidBody2D

onready var g = weakref($"Ground detector/CollisionShape2D")
onready var t = $DestructionTimer
onready var bullet_collider = weakref($Bullet_shape)
onready var bounce_collider = weakref($BounceHit/CollisionShape2D)
onready var sprite = $Sprite
onready var particles = $Particles2D
onready var death_particle = $death_particle
onready var sound = $Sound

func _on_Ground_detector_body_entered(body):
	_on_BounceHit_bounced_player()

func _on_BounceHit_bounced_player():
	if g.get_ref():
		g.get_ref().queue_free()
	if bullet_collider.get_ref():
		bullet_collider.get_ref().queue_free()
	if not bounce_collider.is_queued_for_deletion():
		bounce_collider.get_ref().queue_free()
	sprite.visible = false
	particles.emitting = false
	death_particle.emitting = true
	sound.hit_sound()
	t.start(2)
	yield(t, "timeout")
	queue_free()
