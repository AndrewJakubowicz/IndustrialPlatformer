extends "res://Scripts/StateMachine.gd"

enum STATE {
	UP
	DOWN
	IDLE
}

func _ready():
	for state in STATE:
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.UP])

func _state_logic(delta):
	match state:
		STATE.IDLE:
			pass
		STATE.UP:
			parent.moveUp(delta)
		STATE.DOWN:
			parent.moveDown(delta)

# This will check if we can transition
func _get_transition(delta):
	if [STATE.UP].has(state) and parent.is_on_ceiling():
		return STATE.DOWN
	if [STATE.DOWN].has(state) and parent.is_on_floor():
		return STATE.UP
	return null
	
func _enter_state(new_state, old_state):
	# Start tweens in timers.
	# Start animations.
	pass

func _exit_state(old_state, new_state):
	pass