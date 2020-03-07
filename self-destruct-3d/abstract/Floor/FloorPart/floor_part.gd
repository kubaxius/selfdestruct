extends Spatial

# eg. res://floors/rooms/lab/
export(Array, String, DIR) var room_dirs
# eg. res://floors/rooms/lab/Room1.tscn
export(Array, PackedScene) var single_rooms

export(int, 1, 20) var min_rooms_number = 1
export(int, 1, 20) var max_rooms_number = 3

# If this is true, connections queue no longer works like queue
# but instead next connection is randomized. It makes floor generation more
# random, but can also make it too random.
export(bool) var random_connection = true

onready var floor_instance = get_parent()
onready var rng = floor_instance.rng
onready var roomset = get_packed_rooms()
onready var desired_rooms_count = rng.randi_range(min_rooms_number,
												  max_rooms_number)

var connections_queue = []

# warning-ignore:unused_signal
signal generation_finished
# warning-ignore:unused_signal
signal generation_failed

func generate():
	$StateMachine.current_state = "Generating"

func get_rooms_count():
	return get_child_count() - 1

# import room files from paths and return them in array
func get_packed_rooms() -> Array:
	var single_rooms_paths = []
	
	for path in room_dirs:
		single_rooms_paths += Helper.list_files_in_directory(path)
	
	var packed_rooms = []
	packed_rooms += single_rooms
	
	for path in single_rooms_paths:
		packed_rooms.append(load(path))

	return packed_rooms

# check every room on the list in random order and if any of them
# can be connected to current_connection do this, and return connected_room
func connect_random_room(current_connection: RoomConnection):
	var roomset_copy = roomset.duplicate()
	while roomset_copy.size() > 0:
		var current_room = Helper.pop_random_item(roomset_copy, rng).instance()
		var current_room_connections = current_room.get_empty_connections()
		
		for connection in current_room_connections:
			if current_connection.does_connection_match(connection):
				# move room to position
				current_room.transform = current_connection.get_room_transform(connection)
				if floor_instance.can_room_be_placed(current_room):
					add_child(current_room)
					current_connection.connect_room(connection)
					return current_room
	return false

func _on_previous_floor_part_generation_finished():
	generate()

func place_random_room():
	var connected_room
	# if this is first room to be placed
	if get_tree().get_nodes_in_group("rooms").size() == 0:
		connected_room = Helper.get_random_item(roomset, rng).instance()
		add_child(connected_room)
		connected_room.add_to_group("first_room")
	elif connections_queue.size() > 0:
		var connection
		if random_connection:
			connection = Helper.pop_random_item(connections_queue, rng)
		else:
			connection = connections_queue.pop_front()
		connected_room = connect_random_room(connection)
	else:
		$StateMachine.current_state = "Failed"
	
	# if connection was successful
	if typeof(connected_room) == TYPE_OBJECT:
		connections_queue += connected_room.get_empty_connections()
