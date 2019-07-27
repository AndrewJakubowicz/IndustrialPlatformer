extends KinematicBody2D

export (float) var friction = 20
export (float) var maxSpeed = 125
export (float) var WALK_SPEED = 350
export (float) var VERTICAL_SPEED = 1200

export (float) var JUMP_IMPULSE = 200
export (float) var HURT_BUMP = 60

export (float) var MAX_HEALTH = 3

onready var animation_sprite = $character_sprites
onready var damage_state_machine = $TakeDamageStateMachine

const GRAVITY = 600
const jump_buffer_amount = 0.13

export (int) var health = 1

var acc = Vector2()
var velocity = Vector2()
var air_time = 0
var facing_left = false

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

func _ready():
	damage_state_machine.set_max_health(MAX_HEALTH)

func idle_physics(delta):
	if is_on_floor():
		velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)


func run_physics(delta):
	if Input.is_action_pressed("right"):
		acc.x = WALK_SPEED
		facing_left = false
		if velocity.x < 0:
			velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)

	elif Input.is_action_pressed("left"):
		facing_left = true
		acc.x = -WALK_SPEED
		if velocity.x > 0:
			velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)

func jump_physics(delta, time_in_jump):
	if Input.is_action_pressed("right"):
		acc.x = WALK_SPEED
		facing_left = false
	elif Input.is_action_pressed("left"):
		acc.x = -WALK_SPEED
		facing_left = true
	if Input.is_action_pressed("jump") and velocity.y < 0:
		acc.y -= max(0, GRAVITY/2 - (GRAVITY/2 * (time_in_jump * time_in_jump) ))


func jump_impulse():
	velocity.y = -JUMP_IMPULSE

func dead_impulse():
	velocity.y = -JUMP_IMPULSE
	velocity.x = JUMP_IMPULSE if facing_left else -JUMP_IMPULSE

func could_jump():
	return (is_on_floor() or air_time < jump_buffer_amount) and inputs.is_action_jump_pressed()

func _physics_process(delta):
	animation_sprite.flip_h = facing_left
	# Air time calculation.
	if not is_on_floor():
		air_time += delta
	else:
		air_time = 0
	
	acc.y += GRAVITY
	acc = acc * delta
	velocity += acc
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clamp(velocity.y, -VERTICAL_SPEED, VERTICAL_SPEED)
	move_and_slide(velocity, Vector2(0, -1))
	acc = Vector2(0,0)
	
	if is_on_floor() or is_on_ceiling():
		velocity.y = 0
	if is_on_wall():
		velocity.x = 0

func _process(delta):
	inputs.update(delta)

func hurt_bump():
	velocity.y = -HURT_BUMP
	velocity.x = HURT_BUMP * 1.4 if facing_left else -HURT_BUMP * 1.4

func player_hit(damage):
	damage_state_machine.hit(damage)