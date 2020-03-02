# this scene is created to show level generator how to connect rooms
extends Position3D
class_name RoomConnection

enum ConnectionType {DOUBLE_DOOR, ROOM_PART}
export(ConnectionType) var type
export(bool) var obligatory = false

export(int, 1, 16) var width = 5

# in cm
export(int, 1, 100) var wall_thickness = 6

export(bool) var active = false

var connected_to

func connect_room(connection):
	connected_to = connection
	connected_to.connected_to = self

func get_room_transform(room_connection):
	var second_wall_thickness = room_connection.wall_thickness
	var t: Transform = global_transform
	t = t.translated(Vector3(0, 0, float(wall_thickness + second_wall_thickness)/100))
	t.basis = t.basis.rotated(global_transform.basis.y, PI)
	t = t * room_connection.transform.inverse()
	return t
	
