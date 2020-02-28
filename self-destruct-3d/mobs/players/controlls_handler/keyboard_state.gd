extends State

func handle_movement():
	var movement_vector = Vector3()
	if Input.is_action_pressed(parent.prefix+"_forward"):
		movement_vector.x += 1
	if Input.is_action_pressed(parent.prefix+"_backward"):
		movement_vector.x += -1
	if Input.is_action_pressed(parent.prefix+"_right"):
		movement_vector.z += 1
	if Input.is_action_pressed(parent.prefix+"_left"):
		movement_vector.z += -1
	
	# normalize walking vector, so walking on an angle is not faster than
	# straight walk
	movement_vector = movement_vector.normalized()
	
	# check for jumping/crouching or flying up/flying down
	if Input.is_action_pressed(parent.prefix+"_jump"):
		movement_vector.y += 1
	if Input.is_action_pressed(parent.prefix+"_crouch"):
		movement_vector.y += -1
	
	parent.set_player_velocity(movement_vector)

func _s_process(event):
	handle_movement()
