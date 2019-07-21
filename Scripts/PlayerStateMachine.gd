extends "res://Scripts/StateMachine.gd"

onready var player = parent
onready var anim_state = player.get_node("AnimationTree").get("parameters/playback")

enum STATE {
	IDLE
	RUN
	JUMP
	FALLING
}

func _ready():
	for state in STATE:
		print_debug("Adding player state '%s'" % state)
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.IDLE])

func _state_logic(delta):
	match state:
		STATE.IDLE:
			player.idle_physics(delta)
		STATE.RUN:
			player.run_physics(delta)
		STATE.JUMP:
			player.jump_physics(delta)

# Automatically is checked for whether we can transition into another state.
#  @returns {STATE | null}
func _get_transition(delta):
	# TODO: Clean up input handling. Should happen seperate ly.
	var pressing = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	if [STATE.IDLE].has(state) and pressing:
		return STATE.RUN
	elif [STATE.RUN].has(state) and not pressing:
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE].has(state) and player.could_jump():
		return STATE.JUMP
	elif [STATE.JUMP, STATE.FALLING].has(state) and player.is_on_floor():
		return STATE.IDLE
	elif [STATE.RUN, STATE.IDLE].has(state) and not player.is_on_floor():
		return STATE.FALLING
	return null

# Great place to start tweens/timers and animations =D
func _enter_state(new_state, old_state):
	match new_state:
		STATE.IDLE:
			anim_state.start("idle")
		STATE.RUN:
			anim_state.start("run")
		STATE.JUMP:
			player.jump_impulse()

func _exit_state(old_state, new_state):
	print_debug("	leaving state ", old_state, " from ", new_state)
	pass


