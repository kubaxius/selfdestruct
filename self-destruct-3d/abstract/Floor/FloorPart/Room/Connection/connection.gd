# this scene is created to show level generator how to connect rooms
tool
extends Position3D
class_name RoomConnection

enum ConnectionType {DOOR, TRAP_DOOR_FLOOR, TRAP_DOOR_CEILING, ROOM_PART}
export(ConnectionType) var type = ConnectionType.DOOR
# if set to TILES, it will fill hole with tiles set by fixing_tile_id
# if set to OBJECT, then it will just show FixingObject that you have to prepare
enum FixType {TILES, OBJECT, NONE}
export(FixType) var fix_type = FixType.TILES
export(int) var fixing_tile_id = 0


export var show_hole_visualization = true

# in tiles
export(int, 1, 16) var hole_width = 2
export(int, 1, 16) var hole_height = 1

# in meters
export(float, 0.01, 1, 0.01) var wall_thickness = 0.06

var connected_to
var main = false

func _ready():
	if not Engine.editor_hint:
		$StateMachine.current_state = type
		hide()

func connect_room(connection):
	main = true
	connected_to = connection
	connected_to.connected_to = self

# return transform of second room if connected via given transform
func get_room_transform(room_connection):
	var second_wall_thickness = room_connection.wall_thickness
	var t: Transform = global_transform
	t = t.translated(Vector3(0, 0, wall_thickness + second_wall_thickness))
	t.basis = t.basis.rotated(global_transform.basis.y, PI)
	t *= room_connection.transform.inverse()
	return t

func get_possible_room_transforms(room_connection):
	var second_wall_thickness = room_connection.wall_thickness
	# gets its own transform
	var t: Transform = global_transform
	# moves transform forward to fit summed thickness of both walls
	t = t.translated(Vector3(0, 0, wall_thickness + second_wall_thickness))
	# rotates transform 180 degrees along y axis
	t.basis = t.basis.rotated(transform.basis.y, PI)
	t *= room_connection.transform.inverse()
	return t

func fix_hole():
	if fix_type == FixType.TILES:
		$StateMachine.current_state.fix_hole()
	elif fix_type == FixType.OBJECT:
		if has_node("FixingObject"):
			$FixingObject.show()
		else:
			push_error("No FixingObject even though it is set to use it")

func place_door():
	$StateMachine.current_state.place_door()

func does_connection_match(connection) -> bool:
	return $StateMachine.current_state.does_connection_match(connection)

func _process(delta):
	if Engine.editor_hint:
		$StateMachine.get_child(type)._s_tool_processing(delta)
