# this scene is created to show level generator how to connect rooms
extends Position3D
class_name RoomConnection

enum ConnectionType {DOOR, TRAP_DOOR_FLOOR, TRAP_DOOR_CEILING, ROOM_PART}
export(ConnectionType) var type

# in tiles
export(int, 1, 16) var hole_width = 2
export(int, 1, 16) var hole_height = 1

export(int) var fixing_tile_id = 0

# in meters
export(float, 0.01, 1, 0.01) var wall_thickness = 0.06

var connected_to
var main = false

func _ready():
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

func fix_hole():
	$StateMachine.current_state.fix_hole()

func place_door():
	$StateMachine.current_state.place_door()

func does_connection_match(connection) -> bool:
	return $StateMachine.current_state.does_connection_match(connection)
