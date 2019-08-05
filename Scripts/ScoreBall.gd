extends Node2D

signal collected_checkpoint

onready var p1 = $VisibilityEnabler2D/Particle1
onready var p2 = $VisibilityEnabler2D/Particle2
onready var light = $VisibilityEnabler2D/Light2D

onready var sprite = $VisibilityEnabler2D/Sprite
onready var collider = $Area2D

func create_timer ():
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	return t

func _on_Area2D_body_entered(body):
	p2.emitting = false
	p1.emitting = false
	sprite.queue_free()
	collider.queue_free()
	light.queue_free()
	
	emit_signal("collected_checkpoint", global_position)

	var t = create_timer()
	t.start()
	yield(t, "timeout")
	queue_free()
