extends Node2D

onready var gun_top = $gun_top
var player_to_follow = null
var _flipped_state = false

onready var Bullet = load("res://Prefabs/Bullet.tscn") as PackedScene
onready var _rotated_state = 360 > abs(fmod(rotation_degrees, 360)) and abs(fmod(rotation_degrees, 360)) > 178
onready var fire_rate_timer = $Timer
onready var tween = $Tween
onready var sound = $Sound
enum FireMode {
	STRAIGHT
	GUESS_SHOT
}

var _off = true

export (float) var fire_rate_sec = 1.5
export (float) var random_scatter_fire_rate = 0
export (float) var initial_delay = 0
export (float) var bullet_speed = 80
export (FireMode) var mode = FireMode.STRAIGHT

export (NodePath) var override_target_path
var override_target

func _ready():
	if override_target_path:
		override_target = get_node(override_target_path)
	fire_rate_timer.wait_time = fire_rate_sec
	start_shot_timer(initial_delay)

func start_shot_timer(delay=0):
	fire_rate_timer.start(fire_rate_sec + rand_range(0, random_scatter_fire_rate) + delay)

func _physics_process(delta):
	if override_target:
		tween.interpolate_property(gun_top, "rotation", gun_top.rotation, override_target.position.angle_to_point(gun_top.position), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif player_to_follow:
		tween.interpolate_property(gun_top, "rotation", gun_top.rotation, gun_top.global_position.angle_to_point(player_to_follow.global_position), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		return
	tween.start()
	var rot_normal = fmod(gun_top.rotation_degrees, 360)
	if rot_normal < 270 and rot_normal > 90:
		_switch(true)
	else:
		_switch(false)


func _switch(to_new_state):
	if _flipped_state == to_new_state:
		return
	gun_top.flip_h = to_new_state
	_flipped_state = to_new_state
	if to_new_state:
		gun_top.scale *= -1
	else:
		gun_top.scale *= -1

## GROUP METHOD CALLS

func set_current_player(p):
	player_to_follow = p

func unset_current_player():
	player_to_follow = null;


func _on_Timer_timeout():
	if _off:
		return
	var b = Bullet.instance()
	var direction = Vector2(cos(gun_top.rotation), sin(gun_top.rotation))
	var gun_end_offset = -5 if _rotated_state else 5
	b.position = position + (Vector2(cos(global_rotation-PI/2), sin(global_rotation-PI/2)).normalized() * 10) + (direction.normalized() * gun_end_offset)
	get_tree().get_root().add_child(b)
	b.apply_impulse(Vector2(), direction.normalized() * bullet_speed * (-1 if _rotated_state else 1))
	sound.play_shot()
	start_shot_timer()


func _on_Area2D_area_entered(area):
	set_physics_process(true)
	_off = false


func _on_Area2D_area_exited(area):
	set_physics_process(false)
	_off = true
