extends Spatial

func _ready():
	pass

func get_door_transforms():
	var transforms = []
	var walls: GridMap = $Walls
	for cell_pos in walls.get_used_cells():
		print(walls.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z))

func get_connections():
	return $Connections.get_children()


func get_array_of_wall_shapes_and_their_transforms():
	var shapes_array = $Walls.get_meshes()
	
	for i in shapes_array.size():
		if typeof(shapes_array[i]) == TYPE_OBJECT:
			shapes_array[i] = shapes_array[i].create_convex_shape()
		else:
			shapes_array[i] *= transform
	
	return shapes_array
