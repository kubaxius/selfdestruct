extends State

func _s_init():
	parent.connections_queue = parent.floor_instance.get_all_empty_connections()

func _s_physics_process(_delta):
	if parent.get_rooms_count() < parent.desired_rooms_count:
		parent.place_random_room()
	else:
		get_parent().current_state = "Ready"
