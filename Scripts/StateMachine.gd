extends Node
class_name StateMachine

var state = null
var previous_state = null
var states = {}

onready var parent = get_parent()


func _state_logic(delta):
	pass

# This will check if we can transition
func _get_transition(delta):
	return null
	
func _enter_state(new_state, old_state):
	# Start tweens in timers.
	# Start animations.
	pass

func _exit_state(old_state, new_state):
	pass

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

# String name as param
func add_state(state_name):
	states[state_name] = state_name
