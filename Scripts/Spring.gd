extends Area2D

onready var timer = $CooldownTimer
onready var sprite = $Sprite
onready var top_sprite = $top


var cooldown = false

enum Direction {
	UP
	DOWN
	LEFT
	RIGHT
}

export (Direction) var dir = Direction.UP
export (float) var power = 300
export (float) var cooldown_time = 0.3

func cooldown():
	cooldown = true
	sprite.frame = 1
	top_sprite.visible = true
	timer.start(cooldown_time)
	yield(timer, "timeout")
	cooldown = false
	sprite.frame = 0
	top_sprite.visible = false

func _on_Spring_body_entered(body):
	if cooldown:
		return
	# FIXME: Attempt to call function impluse in base freed instance on a null instance spring line 45
	if body.has_method('impulse'):
		timer.start(0.06)
		yield(timer, "timeout")
		match dir:
			Direction.UP:
				body.impulse(power, Vector2.UP)
				cooldown()
			Direction.DOWN:
				body.impulse(power, Vector2.DOWN)
				cooldown()
			Direction.LEFT:
				body.impulse(power, Vector2.LEFT)
				cooldown()
			Direction.RIGHT:
				body.impulse(power, Vector2.RIGHT)
				cooldown()
