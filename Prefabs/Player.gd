extends KinematicBody2D

export (float) var friction = 20
export (float) var maxSpeed = 125
export (float) var WALK_SPEED = 350

export (float) var JUMP_IMPULSE = 270


onready var animation_sprite = $character_sprites

const GRAVITY = 600
const jump_buffer_amount = 0.13

var acc = Vector2()
var velocity = Vector2()

var air_time = 0

# Provide 6 frames of buffer to time the perfect jump.
class InputBuffer:
	var jump_buffer = 0
	func update(delta):
		jump_buffer = max(0, jump_buffer-delta)
		if Input.is_action_just_pressed("jump"):
			pressed_jump()

	func pressed_jump():
		jump_buffer = jump_buffer_amount

	func is_action_jump_pressed():
		return jump_buffer > 0

var inputs = InputBuffer.new()

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
	if Input.is_action_pressed("right"):
		acc.x = WALK_SPEED
		animation_sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		acc.x = -WALK_SPEED
		animation_sprite.flip_h = true

func jump_impulse():
	velocity.y = -JUMP_IMPULSE

func could_jump():
	return (is_on_floor() or air_time < jump_buffer_amount) and inputs.is_action_jump_pressed()

func _physics_process(delta):
	acc.y += GRAVITY
	# TODO: Add jump.
	# TODO: Add jump buffer. (lets you jump a bit before or a bit after touchdown)
	acc = acc * delta
	velocity += acc
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	move_and_slide(velocity, Vector2(0, -1))
	acc = Vector2(0,0)
	
	# Air time calculation.
	if not is_on_floor():
		air_time += delta
	else:
		air_time = 0
	
	if is_on_floor() or is_on_ceiling():
		velocity.y = 0
	if is_on_wall():
		velocity.x = 0
	

func _process(delta):
	inputs.update(delta)