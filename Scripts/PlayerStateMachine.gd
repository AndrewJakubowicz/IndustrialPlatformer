extends "res://Scripts/StateMachine.gd"

onready var player = parent
onready var anim_state = player.get_node("AnimationTree").get("parameters/playback")
onready var attack_swish = player.get_node("AttackParticle")
onready var attack_swish_player = attack_swish.get_node("AttackAnimPlayer")
onready var damage_state = $"../TakeDamageStateMachine"

enum STATE {
	IDLE
	RUN
	JUMP
	FALLING
	ATTACK_GROUND
	DEAD
}

func _ready():
	for state in STATE:
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.IDLE])

func _state_logic(delta):
	match state:
		STATE.IDLE:
			player.idle_physics(delta)
		STATE.RUN:
			player.run_physics(delta)
		STATE.JUMP:
			player.jump_physics(delta, time_in_state)
		STATE.ATTACK_GROUND:
			player.idle_physics(delta)
		STATE.DEAD:
			player.idle_physics(delta)
			if time_in_state > 2:
				get_tree().reload_current_scene()

# Automatically is checked for whether we can transition into another state.
#  @returns {STATE | null}
func _get_transition(delta):
	# TODO: Clean up input handling. Should happen seperate ly.
	var pressing = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	if [STATE.IDLE].has(state) and pressing:
		return STATE.RUN
	elif [STATE.RUN].has(state) and not pressing:
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE, STATE.FALLING].has(state) and player.could_jump():
		return STATE.JUMP
	elif [STATE.JUMP, STATE.FALLING].has(state) and player.is_on_floor():
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE].has(state) and not player.is_on_floor():
		return STATE.FALLING
	elif [STATE.RUN, STATE.IDLE].has(state) and Input.is_action_just_pressed("attack"):
		return STATE.ATTACK_GROUND
	elif [STATE.ATTACK_GROUND].has(state) and not attack_swish_player.is_playing():
		return STATE.IDLE
	elif not [STATE.DEAD].has(state) and damage_state.curr_health <= 0:
		return STATE.DEAD
	return null

# Great place to start tweens/timers and animations =D
func _enter_state(new_state, old_state):
	match new_state:
		STATE.IDLE:
			anim_state.travel("idle")
		STATE.RUN:
			anim_state.travel("run")
		STATE.JUMP:
			anim_state.travel("jump")
			player.jump_impulse()
		STATE.ATTACK_GROUND:
			if player.facing_left:
				attack_swish.scale.x = -1
			else:
				attack_swish.scale.x = 1
			anim_state.travel("attack_ground")
			attack_swish_player.play("attack_swish")
		STATE.DEAD:
			player.dead_impulse()
			anim_state.start("dead")

func _exit_state(old_state, new_state):
	pass
	#print_debug("%s  -->  %s" % [old_state, new_state])
