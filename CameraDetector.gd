extends Area2D

onready var area_shape = $CollisionShape2D

## Called when the node enters the scene tree for the first time.
#func _ready():
#	assert(tilemapPath != null)
#	tileMap = get_node(tilemapPath)

func _on_CameraDetector_body_entered(body):
	get_tree().call_group('camera', 'camera', global_position, area_shape.shape.extents)
