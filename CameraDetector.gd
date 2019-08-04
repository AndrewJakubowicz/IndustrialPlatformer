extends Area2D

onready var area_shape = $CollisionShape2D

func _on_CameraDetector_body_entered(body):
	get_tree().call_group('camera', 'camera', global_position, area_shape.shape.extents)


func _on_CameraDetector_area_entered(area):
	get_tree().call_group('camera', 'camera', global_position, area_shape.shape.extents)
