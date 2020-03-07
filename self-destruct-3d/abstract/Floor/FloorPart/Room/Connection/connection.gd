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
export(float, 0, 1, 0.01) var wall_thickness = 0.06

export(PackedScene) var door_file

onready var room = get_parent().get_parent()
var connected_to
var main = false

func _ready():
	$StateMachine.current_state = type
	# hide hints shown in editor
	$Arrow.hide()
	$HoleVisualization.hide()

func connect_room(connection):
	main = true
	connected_to = connection
	connected_to.connected_to = self
	place_door()
	$StateMachine.current_state.connect_room(connection)

func get_possible_room_transforms(room_connection) -> Array:
	return $StateMachine.current_state.get_possible_room_transforms(room_connection)

func fix_hole():
	if fix_type == FixType.TILES:
		$StateMachine.current_state.fix_hole()
	elif fix_type == FixType.OBJECT:
		if has_node("FixingObject"):
			# TODO: Reparent it
			$FixingObject.show()
		else:
			push_error("No FixingObject even though it is set to use it")

func place_door():
	if typeof(door_file) != TYPE_NIL:
		add_child(door_file.instance())

func does_connection_match(connection) -> bool:
	return $StateMachine.current_state.does_connection_match(connection)

func _process(delta):
	if Engine.editor_hint:
		$StateMachine.get_child(type)._s_tool_processing(delta)
