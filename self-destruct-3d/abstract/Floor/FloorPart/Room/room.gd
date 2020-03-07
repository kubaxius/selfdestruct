extends Spatial
class_name Room

func get_empty_connections() -> Array:
	var connections = []
	
	for connection in $Connections.get_children():
		if not typeof(connection.connected_to) == TYPE_OBJECT:
			connections.append(connection)
	
	return connections

# example return:
# [0]: Transform
# [1]: ConvexPolygonShape
# [2]: Transform
# [3]: ConvexPolygonShape
# Have to do this this way because for some weird reason when I try to pass
# array of PhysicsShapeQueryParameters game just crashes
func get_array_of_shapes_and_their_transforms() -> Array:
	var shapes_array = []
	shapes_array += $Walls.get_meshes()
	shapes_array += $Floors.get_meshes()
	shapes_array += $Ceilings.get_meshes()
	
	for i in shapes_array.size():
		if typeof(shapes_array[i]) == TYPE_TRANSFORM:
			shapes_array[i] = transform * shapes_array[i]
		else:
			shapes_array[i] = shapes_array[i].create_convex_shape()
	return shapes_array

func player_entered():
	$Ceilings.fade_out()

func player_exited():
	$Ceilings.fade_in()

func _ready():
	pass#$Ceilings.fade_out()

func place_player(player):
	add_child(player)
	player.transform = $PlayerSpawnPoint.transform
	player_entered()
