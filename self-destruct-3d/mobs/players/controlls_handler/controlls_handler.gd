extends Node

# controls prefix - used when there is more than one player on one PC
var prefix = "p1"

var input_device = "Keyboard"

func _ready():
	$StateMachine.set_current_state(input_device)

func set_player_velocity(vector: Vector3):
	var parent = get_parent()
	parent.desired_velocity.x = vector.x
	parent.desired_velocity.z = vector.z
	parent.desired_velocity = parent.desired_velocity * parent.max_speed
