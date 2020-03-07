extends Spatial

# it is a inverse of standard collision margin, to nullify placed rooms
# collision margin - it makes it possible to place rooms touching other rooms
const rooms_collision_margin = -0.05

var rng = RandomNumberGenerator.new()
onready var floor_parts = Helper.get_children_in_group(self, "floor_parts")

signal generation_finished

# return all empty connections of all placed rooms
func get_all_empty_connections():
	var empty_connections = []
	for room in get_tree().get_nodes_in_group("rooms"):
		empty_connections += room.get_empty_connections()
	return empty_connections

func fix_empty_connections_holes():
	var connections = get_all_empty_connections()
	for connection in connections:
		connection.fix_hole()

# take room walls from its GridMap and try to collide them with any
# existing shapes on ENVIROMENT collision layer
func can_room_be_placed(room: Room) -> bool:
	var space_state = get_world().direct_space_state
	var room_shapes_and_transforms = room.get_array_of_shapes_and_their_transforms()
	var psqp
	for item in room_shapes_and_transforms:
		if typeof(item) == TYPE_TRANSFORM:
			# if this item is transform
			psqp = PhysicsShapeQueryParameters.new()
			psqp.transform = item
			psqp.collision_mask = 1
		else:
			# if this item is a ConvexPolygonShape
			# set collision margin
			item.margin = rooms_collision_margin
			psqp.set_shape(item)
			if space_state.collide_shape(psqp).size() > 0:
				return false
	return true

func _on_generation_failed():
	push_error("Floor generation failed")
	assert(false)

func _on_floor_parts_generation_finished():
	fix_empty_connections_holes()
	emit_signal("generation_finished")

# creates queue of signals - when first FloorPart finishes generation, it sends
# signal that starts next FloorPart generation and so on
func setup_generation_signals():
	for i in floor_parts.size():
		# if there is next FloorPart, connect it to this 
		# FloorPart signal "generation_finished"
		if i+1 < floor_parts.size():
			floor_parts[i].connect("generation_finished", 
			floor_parts[i+1], "_on_previous_floor_part_generation_finished")
		else:
		# if this is the last FloorPart
			floor_parts[i].connect("generation_finished", 
			self, "_on_floor_parts_generation_finished")
		
		
		floor_parts[i].connect("generation_failed", 
								self, "_on_generation_failed")

func _ready():
	rng.seed = hash(OS.get_ticks_msec())
	setup_generation_signals()
	floor_parts[0].generate()
