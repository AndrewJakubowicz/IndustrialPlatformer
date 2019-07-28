extends "res://Scripts/StateMachine.gd"

enum STATE {
	MOVE_LEFT,
	MOVE_RIGHT,
	IDLE,
	STUNNED
}

func _ready():
	for state in STATE:
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.IDLE])

func _state_logic(delta):
	match state:
		STATE.MOVE_LEFT:
			parent.move_left_logic(delta)
		STATE.MOVE_RIGHT:
			parent.move_right_logic(delta)
		STATE.IDLE:
			parent.not_moving(delta)
		STATE.STUNNED:
			parent.not_moving(delta)

# This will check if we can transition
func _get_transition(delta):
	if state == STATE.STUNNED and time_in_state > 1:
		return STATE.IDLE
	if state == STATE.IDLE and parent.is_on_floor():
		return [STATE.MOVE_RIGHT, STATE.MOVE_LEFT][floor(rand_range(0, 2))]
	if state == STATE.MOVE_LEFT and parent.is_on_wall():
		parent.velocity.x = 0
		return STATE.MOVE_RIGHT
	if state == STATE.MOVE_RIGHT and parent.is_on_wall():
		parent.velocity.x = 0
		return STATE.MOVE_LEFT
	if not [STATE.STUNNED].has(state) and not parent.is_on_floor():
		return STATE.IDLE


func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass


func _on_TakeDamageState_got_hit():
	set_state(STATE.STUNNED)
