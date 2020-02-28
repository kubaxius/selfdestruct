extends Spatial

signal generation_finished

#set generator to generate mazes or corridors
var corridor_mode = false

enum floors {GROUND_FLOOR}

var floors_settings_paths = {
	floors.GROUND_FLOOR: "res://floors/ground_floor.json",
	}

var rng = RandomNumberGenerator.new()

func _ready():
	pass
	#generate_floor(floors.GROUND_FLOOR)

#import rooms files from paths and return them in array
func _get_packed_rooms(rooms_paths: Array) -> Array:
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

func generate_floor(floor_name):
	var floor_settings = Helper.parse_json_from_path(floors_settings_paths[floor_name])
	print(floor_settings)

	for room_type in floor_settings["rooms"]:
		var packed_rooms = _get_packed_rooms(floor_settings["rooms"][room_type]["paths"])
		var min_rooms_number = floor_settings["rooms"][room_type]["min_number"]
		var max_rooms_number = floor_settings["rooms"][room_type]["max_number"]
		var desired_rooms_number = rng.randi_range(min_rooms_number, max_rooms_number)
		
		for packed_room in packed_rooms:
			add_child(packed_room.instance())
		
	emit_signal("generation_finished")
