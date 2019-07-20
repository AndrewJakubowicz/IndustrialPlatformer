extends KinematicBody2D

export (float) var friction = 20
export (float) var maxSpeed = 125
export (float) var WALK_SPEED = 350


onready var animation_sprite = $character_sprites

const GRAVITY = 300

var acc = Vector2()
var velocity = Vector2()


func idle_physics(delta):
	# TODO: Assume don't need gravity.
	# What happens if the floor suddenly falls out from underneath the character?
	velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)

func run_physics(delta):
	if Input.is_action_pressed("right"):
		acc.x = WALK_SPEED
		animation_sprite.flip_h = false
		if velocity.x < 0:
			velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)

	elif Input.is_action_pressed("left"):
		animation_sprite.flip_h = true
		acc.x = -WALK_SPEED
		if velocity.x > 0:
			velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)

func jump_physics(delta):
	velocity.y = 0
	acc.y += 1000

func could_jump():
	return is_on_floor() and Input.is_action_pressed("jump")

func _physics_process(delta):
	acc.y += GRAVITY
	# TODO: Add jump.
	# TODO: Add jump buffer. (lets you jump a bit before or a bit after touchdown)
	acc = acc * delta
	velocity += acc
	velocity = velocity.clamped(maxSpeed)
	move_and_slide(velocity, Vector2(0, -1))
	acc = Vector2(0,0)
