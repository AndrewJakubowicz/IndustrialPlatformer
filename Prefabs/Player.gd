extends KinematicBody2D

export (float) var friction = 0.65
export (float) var maxSpeed = 1000
export (float) var WALK_SPEED = 300


onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")
onready var animation_sprite = $character_sprites

const GRAVITY = 300


func _ready():
	state_machine.start("idle")


var velocity = Vector2()

func _process(delta):
	if abs(velocity.x) > 3:
		state_machine.travel("run")
	else:
		state_machine.travel("idle")


func _physics_process(delta):
	
	# TODO: Create sensors for hitting ground and reset velocity.
	# TODO: Add jump.
	# TODO: Add jump buffer. (lets you jump a bit before or a bit after touchdown)
	var acc = Vector2(0, 0)
	acc.y += GRAVITY
	
	if Input.is_action_pressed("right"):
		acc.x = WALK_SPEED
		animation_sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		animation_sprite.flip_h = true
		acc.x = -WALK_SPEED
	else:
		# Nothing pressed
		velocity = velocity.linear_interpolate(Vector2(0,0), friction * delta)
	
	acc = acc * delta
	
	velocity += acc
	
	velocity = velocity.clamped(maxSpeed)
	
	move_and_slide(velocity, Vector2(0, -1))
	
