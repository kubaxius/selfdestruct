extends Spatial

signal generation_finished


enum floors {GROUND_FLOOR}

var floors_settings_paths = {
	floors.GROUND_FLOOR: "res://floors/ground_floor.json",
	}

var rooms_groups_prefix = "rooms_set_"
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = hash("dupaa")
	generate_floor(floors.GROUND_FLOOR)

func get_all_empty_connections():
	var empty_connections = []
	for room in get_children():
		empty_connections += room.get_empty_connections()
	return empty_connections

# import rooms files from paths and return them in array
func get_packed_rooms(rooms_paths: Array) -> Array:
	var single_rooms_paths = []
	
	for path in rooms_paths:
		if path.ends_with("*"):
			single_rooms_paths += Helper.list_files_in_directory(path.rstrip("*"))
		else:
			single_rooms_paths.append(path)
	
	var packed_rooms = []
	
	for path in single_rooms_paths:
		packed_rooms.append(load(path))
		
	return packed_rooms

# take room walls (and floors sometimes) and try to collide them with any
# existing shapes on ENVIROMENT collision layer
func can_room_be_placed(room: Room) -> bool:
	var space_state = get_world().direct_space_state
	var room_shapes_and_transforms = room.get_array_of_shapes_and_their_transforms()
	var psqp
	for item in room_shapes_and_transforms:
		if typeof(item) == TYPE_TRANSFORM:
			psqp = PhysicsShapeQueryParameters.new()
			psqp.transform = item
			psqp.collision_mask = 1
		else:
			psqp.set_shape(item)
			if space_state.collide_shape(psqp).size() > 0:
				return false
	return true

# check every room on the list in random order and if any of them
# can be connected to current_connection do this, and return true
func connect_random_room(current_connection: RoomConnection, current_rooms_set: Array) -> bool:
	while current_rooms_set.size() > 0:
		var current_room = Helper.pop_random_item(current_rooms_set, rng).instance()
		var current_room_connections = current_room.get_empty_connections()
		
		for connection in current_room_connections:
			if current_connection.type == connection.type:
				current_room.transform = current_connection.get_room_transform(connection)
				if can_room_be_placed(current_room):
					current_connection.connect_room(connection)
					add_child(current_room)
					return true
	
	return false

# generate all rooms from set and returns true, if there is no room that fits
# any of the free connections, then returns false
func generate_rooms_set(rooms_set: Array, desired_number: int) -> bool:
	var empty_connections = get_all_empty_connections()
	var placed_rooms_number = 0
	
	while placed_rooms_number < desired_number:
		if get_child_count() == 0:
			add_child(Helper.get_random_item(rooms_set, rng).instance())
			placed_rooms_number += 1
			empty_connections = get_all_empty_connections()
		else:
			if empty_connections.size() == 0:
				return false
			
			var current_rooms_set = rooms_set.duplicate()
			var connection_successfull = connect_random_room(empty_connections.pop_front(), current_rooms_set)
			
			if connection_successfull:
				placed_rooms_number += 1
				
				# VERY IMPORTANT, wait to the next frame before moving on -
				# it ensures that room placed this time will be taken into
				# consideration in the next collision check
				yield(VisualServer, 'frame_post_draw')
				
				empty_connections = get_all_empty_connections()
	return true

func generate_floor(floor_name):
	var floor_settings = Helper.parse_json_from_path(floors_settings_paths[floor_name])

	for rooms_set in floor_settings["rooms"]:
		var packed_rooms = get_packed_rooms(floor_settings["rooms"][rooms_set]["paths"])
		var desired_rooms_number = rng.randi_range(floor_settings["rooms"][rooms_set]["min_number"],
		floor_settings["rooms"][rooms_set]["max_number"])
		var rooms_generated_correctly = generate_rooms_set(packed_rooms, desired_rooms_number)
		
	emit_signal("generation_finished")
