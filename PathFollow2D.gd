extends PathFollow2D

func _process(delta):
	set_offset(get_offset() + 100 * delta)