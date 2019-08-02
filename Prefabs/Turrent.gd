extends Node2D

onready var target = $Target
onready var gun_top = $gun_top
var player_to_follow = null

var _flipped_state = false

onready var Bullet = load("res://Prefabs/Bullet.tscn") as PackedScene




func _physics_process(delta):
	if player_to_follow:
		gun_top.look_at(player_to_follow.position)
	else:
		gun_top.look_at(target.position)
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
	print('bullllet fiiiiired')
	var b = Bullet.instance()
	var direction = Vector2(cos(gun_top.rotation), sin(gun_top.rotation))
	b.position = position + Vector2(0, -10) + (direction.normalized() * 5)
	# TODO figure out bullet velocities
	b.applied_force = direction.normalized() * 10
	get_parent().add_child(b)
