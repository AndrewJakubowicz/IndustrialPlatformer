extends Camera2D

onready var tween_limits = $limitsTween

var camera_moves = 0

func _ready():
	camera_moves = 0
	tween_limits.connect("tween_all_completed", self, "_on_limitsTween_tween_all_completed")

func camera(global_pos: Vector2, extents: Vector2):
	# Ensures that if camera is already set it doesn't freeze player.
	if global_pos.x - extents.x - 8 == limit_left and camera_moves != 0:
		return

	camera_moves += 1
	var duration = 0.2
	if camera_moves == 1:
		limit_left = global_pos.x - extents.x - 8
		limit_right = global_pos.x + extents.x + 8
		limit_top = global_pos.y - extents.y - 8
		limit_bottom = global_pos.y + extents.y + 8
		return
		
	get_tree().call_group("freeze", "freeze")
	var limit_left_end = global_pos.x - extents.x - 8
	var limit_right_end = global_pos.x + extents.x + 8
	var limit_top_end = global_pos.y - extents.y - 8
	var limit_bottom_end = global_pos.y + extents.y + 8

	tween_limits.interpolate_property(self, "limit_left", limit_left, limit_left_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_right", limit_right, limit_right_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_top", limit_top, limit_top_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_bottom", limit_bottom, limit_bottom_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.start()

func _on_limitsTween_tween_all_completed():
	OS.delay_msec(150)
	get_tree().call_group("freeze", "unfreeze")