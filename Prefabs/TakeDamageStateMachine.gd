extends "res://Scripts/StateMachine.gd"

signal got_hit
signal recovered_hit
signal died

export (float) var time_of_no_damage = 0.2

var max_health = 1;
var curr_health = max_health;

enum STATE {
	CAN_TAKE_DAMAGE
	NO_TAKE_DAMAGE
}

func _ready():
	for state in STATE:
		add_state(STATE[state])

	call_deferred('set_state', states[STATE.CAN_TAKE_DAMAGE])

func set_max_health(health):
	max_health = health
	curr_health = health

func _state_logic(delta):
	pass

# This will check if we can transition
func _get_transition(delta):
	if [STATE.NO_TAKE_DAMAGE].has(state) and time_in_state > time_of_no_damage:
		return STATE.CAN_TAKE_DAMAGE

func _enter_state(new_state, old_state):
	match new_state:
		STATE.NO_TAKE_DAMAGE:
			emit_signal("got_hit")
			curr_health -= 1
			if curr_health <= 0:
				emit_signal("died")
		STATE.CAN_TAKE_DAMAGE:
			emit_signal("recovered_hit")


func _exit_state(old_state, new_state):
	pass

func hit(damage):
	if [STATE.CAN_TAKE_DAMAGE].has(state):
		set_state(STATE.NO_TAKE_DAMAGE)
