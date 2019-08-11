extends Node2D

export (bool) var will_reset = true
export (int) var reset_time = 5
export (float) var about_to_drop_time = 0.4

onready var platform = $Platform
onready var timer = $Timer
onready var area2d = $Area2D

func reset():
	if will_reset:
		return
	if platform.position_up:
		return
	platform.toggle()


var _running = false

func handle_player_touch():
	if not platform.position_up:
		return

	timer.start(about_to_drop_time)
	yield(timer, "timeout")
	platform.toggle()
	if not will_reset:
		return
	timer.start(reset_time)
	yield(timer, "timeout")
	platform.toggle()

func _on_Area2D_body_entered(body):
	if _running:
		return
	if body.get('velocity'):
		if body.velocity.y < 0:
			return
	print_debug(body)
	_running = true
	handle_player_touch()
	_running = false
