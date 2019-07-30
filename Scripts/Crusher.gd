tool
extends KinematicBody2D

## The crusher chooses a direction and goes until it hits something.

# TODO: Add a state machine for picking a direction.
# I want to create a couple crusher variations so we want the state machine to
# be picked via an enum. The crusher should have the following.

## BEHAVIORS?
# [p0] An auto trigger mode with set timers. (I.e. the typical crush up and down)
# [p1] A taunted version where the center is slightly lit up. And it flashes the direction it
#   will crush befor crushing. Often towards the player. Should have friction against
#  walls, floor and ceiling. But no gravity. Travels very robotically with constant velocity.
#  Should be quite intimidating and cause a screen shake.
# [??] A follow a path variation that is guided on rails and can pathfind to be nearest to the player.
#   If too hard make it a single rail.

# Game elements???
# This crusher will tie in with other elements such as:
#  - Destructable terrain. These are blocks you can't destroy but crusher can.
#  - Crusher intro is by crushing a slime.

# COLLIDERS???
# - How to detect crush? When a collider is squashed an inner collider might be exposed.
#   Make this inner collider detect squash if it is reached.

## ANIMATIONS

# When smashes into ground have the little diamond appear.
# We want the full inner glow for "sentience" to be a surprise :P
# Will use opacity and face ins to bring the other glow in.

onready var waypoints = get_node(waypoints_path)

export var editor_process = true setget set_editor_process

export var waypoints_path = NodePath()


var target_position = Vector2()

const maxSpeed = 500
var acc = Vector2()
var velocity = Vector2()

func _ready():
	if not waypoints:
		set_physics_process(false)
		return
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()

func moveUp (delta):
	acc.y = -maxSpeed

func moveDown (delta):
	acc.y = maxSpeed

func _physics_process(delta):
#	acc = acc * delta
#	velocity += acc
#	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
#	velocity.y = clamp(velocity.y, -maxSpeed, maxSpeed)
#	move_and_slide(velocity, Vector2(0, -1))
#	acc = Vector2(0,0)
#
#	if is_on_floor() or is_on_ceiling():
#		velocity.y = 0
	var direction = (target_position - position).normalized()
	var motion = direction * maxSpeed * delta
	var distance_to_target = position.distance_to(target_position)
	if motion.length() > distance_to_target:
		position = target_position
		target_position = waypoints.get_next_point_position()
	else:
		position += motion

func set_editor_process(value: bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_physics_process(value)
