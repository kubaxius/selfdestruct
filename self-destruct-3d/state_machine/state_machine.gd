extends Node
class_name StateMachine

var current_state: State setget set_current_state

var state_history = []

export var physics_processing = false
export var standard_processing = false
export var process_unhandled_input = false
export var process_input = false
export(int, 0, 10) var max_state_history_size = 2

func _ready():
	set_physics_process(physics_processing)
	set_process(standard_processing)
	set_process_input(process_input)
	set_process_unhandled_input(process_unhandled_input)

func _physics_process(delta):
	current_state._s_physics_process(delta)

func _process(delta):
	current_state._s_process(delta)

func _on_signal_received(method_name, params):
	if current_state.has_method(method_name):
		current_state.callv(method_name, params)

func _unhandled_input(event):
	current_state._s_unhandled_input(event)

func _input(event):
	current_state._input(event)

func is_state_set():
	return not (typeof(current_state) == TYPE_NIL)

func set_current_state(state, update_state_history = true):
	# exit from the last state
	if is_state_set():
		current_state._s_exit()
		
		if update_state_history:
			state_history.append(current_state)
			if state_history.size() > max_state_history_size:
				state_history.pop_front()

	# set the new state
	if typeof(state) == TYPE_STRING:
		current_state = get_node(state)
	elif typeof(state) == TYPE_INT:
		current_state = get_child(state)
	elif typeof(state) == TYPE_OBJECT:
		current_state = state

	# init new state
	current_state._s_init()

# set current state to last state in history
func revert_state():
	set_current_state(state_history.pop_back(), false)
