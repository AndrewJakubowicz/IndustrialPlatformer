extends "res://Scripts/StateMachine.gd"

onready var player = parent
onready var anim_state = player.get_node("AnimationTree").get("parameters/playback")
onready var attack_swish = player.get_node("AttackParticle")
onready var attack_swish_player = attack_swish.get_node("AttackAnimPlayer")
onready var damage_state = $"../TakeDamageStateMachine"
onready var audio_player = $"../Sounds"

var in_air_hit_air = false

enum STATE {
	IDLE
	RUN
	JUMP
	FALLING
	ATTACK_GROUND
	ATTACK_AIR
	FALLING_CAN_AIR_JUMP
	DEAD
}

func _ready():
	for state in STATE:
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.IDLE])

func _state_logic(delta):
#	if bunny_hops > 0 and state != STATE.JUMP and time_in_state > 0.18:
#		bunny_hops = 0
#	bunny_hops = min(bunny_hops, 20)
	match state:
		STATE.IDLE:
			player.idle_physics(delta)
		STATE.RUN:
			player.run_physics(delta)
		STATE.JUMP,STATE.ATTACK_AIR,STATE.FALLING,STATE.FALLING_CAN_AIR_JUMP:
			player.jump_physics(delta, time_in_state)
		STATE.ATTACK_GROUND:
			player.idle_physics(delta)
		STATE.DEAD:
			player.idle_physics(delta)
			if time_in_state > 1.4:
				player.request_reload()

# Automatically is checked for whether we can transition into another state.
#  @returns {STATE | null}
func _get_transition(delta):
	var pressing = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	if [STATE.IDLE].has(state) and pressing:
		return STATE.RUN
	elif [STATE.RUN].has(state) and not pressing:
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE, STATE.FALLING].has(state) and player.could_jump():
		return STATE.JUMP
	elif [STATE.FALLING_CAN_AIR_JUMP].has(state) and player.could_air_jump():
		return STATE.JUMP
	elif [STATE.JUMP, STATE.FALLING, STATE.FALLING_CAN_AIR_JUMP, STATE.ATTACK_AIR].has(state) and player.is_on_floor():
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE].has(state) and not player.is_on_floor():
		return STATE.FALLING
	elif [STATE.RUN, STATE.IDLE].has(state) and Input.is_action_just_pressed("attack") and not attack_swish_player.is_playing():
		return STATE.ATTACK_GROUND
	elif [STATE.JUMP, STATE.FALLING, STATE.FALLING_CAN_AIR_JUMP].has(state) and Input.is_action_just_pressed("attack") and not attack_swish_player.is_playing():
		return STATE.ATTACK_AIR
	elif [STATE.ATTACK_AIR].has(state) and not attack_swish_player.is_playing():
		return STATE.FALLING
	elif [STATE.ATTACK_GROUND].has(state) and not attack_swish_player.is_playing():
		return STATE.IDLE
	elif not [STATE.DEAD].has(state) and damage_state.curr_health <= 0:
		return STATE.DEAD
	return null

# Great place to start tweens/timers and animations =D
func _enter_state(new_state, old_state):
	match new_state:
		STATE.IDLE:
			in_air_hit_air = false
			anim_state.travel("idle")
		STATE.RUN:
			anim_state.travel("run")
		STATE.JUMP:
#			bunny_hops += 1
#			player.maxSpeed = player._maxSpeed + (bunny_hops * max_speed_increase)
			anim_state.travel("jump")
		STATE.ATTACK_AIR:
			continue
		STATE.ATTACK_GROUND,STATE.ATTACK_AIR:
			if player.facing_left:
				attack_swish.scale.x = -1
			else:
				attack_swish.scale.x = 1

			if Input.is_action_pressed("down"):
				attack_swish.rotation_degrees = 90 * attack_swish.scale.x
			elif Input.is_action_pressed("up"):
				attack_swish.rotation_degrees = -90 * attack_swish.scale.x
			else:
				attack_swish.rotation = 0

			anim_state.travel("attack_ground")
			attack_swish_player.play("attack_swish")
		STATE.FALLING_CAN_AIR_JUMP:
			in_air_hit_air = true
			player.turn_on_aesthetics_air_jump()
		STATE.DEAD:
			player.dead_impulse()
			anim_state.start("dead")

func _exit_state(old_state, new_state):
	match old_state:
		STATE.FALLING_CAN_AIR_JUMP:
			player.turn_off_aesthetics_air_jump()
	match [old_state, new_state]:
		[STATE.JUMP, STATE.IDLE]:
			audio_player.play_footstep()
		[STATE.IDLE, STATE.JUMP]:
			audio_player.play_jump()
		[STATE.RUN, STATE.JUMP]:
			audio_player.play_jump()

func is_grounded_state ():
	return [STATE.IDLE, STATE.RUN].has(state)

func set_air_jump_state():
	if player.is_on_floor():
		return
	set_state(STATE.FALLING_CAN_AIR_JUMP)
