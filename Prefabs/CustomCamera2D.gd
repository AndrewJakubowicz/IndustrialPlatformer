extends Camera2D

onready var tween_limits = $limitsTween
onready var timer = $Timer

func _ready():
	tween_limits.connect("tween_all_completed", self, "_on_limitsTween_tween_all_completed")

func camera(global_pos: Vector2, extents: Vector2):
	get_tree().call_group("freeze", "freeze")
	var limit_left_end = global_pos.x - extents.x
	var limit_right_end = global_pos.x + extents.x
	var limit_top_end = global_pos.y - extents.y
	var limit_bottom_end = global_pos.y + extents.y
	var duration = 0.2
	tween_limits.interpolate_property(self, "limit_left", limit_left, limit_left_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_right", limit_right, limit_right_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_top", limit_top, limit_top_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.interpolate_property(self, "limit_bottom", limit_bottom, limit_bottom_end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween_limits.start()

func _on_limitsTween_tween_all_completed():
	timer.start()
	yield(timer, "timeout")
	get_tree().call_group("freeze", "unfreeze")