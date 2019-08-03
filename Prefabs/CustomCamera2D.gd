extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called by the group.
# Sets new camera extent
# Idea from https://godotengine.org/qa/27004/techniques-for-changing-the-limits-of-camera2d
#func camera(r: Rect2, cell_size: Vector2):
#	limit_left = r.position.x * cell_size.x
#	limit_right = r.end.x * cell_size.x
#	limit_top = r.position.y * cell_size.y
#	limit_bottom = r.end.y * cell_size.y

func camera(global_pos: Vector2, extents: Vector2):
	limit_left = global_pos.x - extents.x
	limit_right = global_pos.x + extents.x
	limit_top = global_pos.y - extents.y
	limit_bottom = global_pos.y + extents.y
