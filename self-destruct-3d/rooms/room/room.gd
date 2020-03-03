extends Spatial
class_name Room

func get_empty_connections():
	var connections = []
	
	for connection in $Connections.get_children():
		if typeof(connection.connected_to) == TYPE_NIL:
			connections.append(connection)
	
	return connections

func get_array_of_shapes_and_their_transforms():
	var shapes_array = []
	shapes_array += $Walls.get_meshes()
	shapes_array += $Floors.get_meshes()
	
	for i in shapes_array.size():
		if typeof(shapes_array[i]) == TYPE_TRANSFORM:
			shapes_array[i] *= transform
		else:
			shapes_array[i] = shapes_array[i].create_convex_shape()
	return shapes_array
