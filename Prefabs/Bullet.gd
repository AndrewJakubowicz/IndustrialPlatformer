extends RigidBody2D

func _on_Ground_detector_body_entered(body):
	queue_free()
