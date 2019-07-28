extends KinematicBody2D

onready var take_damage = $TakeDamageState
onready var animation_sprite = $Sprite

export (float) var MAX_HEALTH = 2

var max_movement = 100
var facing_left = true
var GRAVITY = global.GRAVITY
var maxSpeed = 100
var VERTICAL_SPEED = 1200


var acc = Vector2()
var velocity = Vector2()

func _ready():
	take_damage.set_max_health(MAX_HEALTH)

func move_left_logic(delta):
	acc.x += maxSpeed

func move_right_logic(delta):
	acc.x -= maxSpeed

func _physics_process(delta):
	facing_left = velocity.x < 0
	animation_sprite.flip_h = facing_left

	acc.y += GRAVITY
	acc = acc * delta
	velocity += acc
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clamp(velocity.y, -VERTICAL_SPEED, VERTICAL_SPEED)
	move_and_slide(velocity, Vector2(0, -1))
	acc = Vector2(0,0)

	if is_on_floor() or is_on_ceiling():
		velocity.y = 0



func _on_Area2D_body_entered(body):
	if body.has_method("player_hit"):
		body.player_hit(1)

func enemy_hit(damage):
	take_damage.hit(damage)

# Specifically hitbox area
func _on_Area2D_area_entered(area):
	# player damage can be a singleton data source.
	enemy_hit(1)


func _on_TakeDamageState_died():
	queue_free()
