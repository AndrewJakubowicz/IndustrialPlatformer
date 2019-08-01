extends KinematicBody2D

onready var take_damage = $TakeDamageState
onready var animation_sprite = $Sprite
onready var animation = $AnimationPlayer

export (float) var MAX_HEALTH = 2

var speed = 50
var facing_left = true
var GRAVITY = global.GRAVITY
var maxSpeed = 100
var VERTICAL_SPEED = 1200

var acc = Vector2()
var velocity = Vector2()

func _ready():
	take_damage.set_max_health(MAX_HEALTH)
	animation.play("slime")

func not_moving(delta):
	if is_on_floor():
		velocity = velocity.linear_interpolate(Vector2(0,0), 5 * delta)

func move_left_logic(delta):
	acc.x += speed

func move_right_logic(delta):
	acc.x -= speed

# Expects damage_source to be a global position
func damage_bump(damage_source):
	velocity.y -= 95
	if damage_source.x > global_position.x:
		# damage source is to the right
		velocity.x = min(velocity.x, 0)
		velocity.x -= 75
	else:
		velocity.x = max(velocity.x, 0)
		velocity.x += 75

func _physics_process(delta):
	facing_left = velocity.x < 0
	animation_sprite.flip_h = facing_left

	acc.y += GRAVITY
	acc = acc * delta
	velocity += acc
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	animation.set_speed_scale(abs(velocity.x / maxSpeed) + 0.5)
	velocity.y = clamp(velocity.y, -VERTICAL_SPEED, VERTICAL_SPEED)
	move_and_slide(velocity, Vector2(0, -1))
	acc = Vector2(0,0)

	if is_on_floor() or is_on_ceiling():
		velocity.y = 0
	if is_on_wall():
		velocity.x = 0


func _on_Area2D_body_entered(body):
	if body.has_method("player_hit"):
		body.player_hit(1)

func enemy_hit(damage):
	take_damage.hit(damage)

# Specifically hitbox area
func _on_Area2D_area_entered(area):
	# player damage can be a singleton data source.
	damage_bump(area.global_position)
	enemy_hit(0)


func _on_TakeDamageState_died():
	queue_free()


func _on_SpikeArea2D_body_entered(body):
	var isFloorSpike = body.rotation_degrees < 3 and body.rotation_degrees > -3
	if (is_on_floor() or velocity.y <= 0) and isFloorSpike:
		return
	enemy_hit(MAX_HEALTH)
