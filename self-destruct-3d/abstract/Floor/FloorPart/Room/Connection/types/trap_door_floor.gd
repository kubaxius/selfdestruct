extends ConnectionType

func does_connection_match(connection) -> bool:
	if connection.type == parent.ConnectionType.TRAP_DOOR_CEILING:
		if parent.hole_width == connection.hole_width:
			if parent.hole_height == connection.hole_height:
				return true
	return false

func get_possible_room_transforms(room_connection) -> Array:
	var second_wall_thickness = room_connection.wall_thickness
	# gets its own transform
	var t: Transform = parent.global_transform
	# moves transform forward to fit summed thickness of both walls
	t = t.translated(Vector3(0, 0, parent.wall_thickness + second_wall_thickness))
	t *= room_connection.transform.inverse()
	
	var t_array = []
	for i in [0, 0.5, 1, 1.5]:
		t_array.append(t.rotated(t.basis.y, i*PI))
	return t_array

func fix_hole():
	var t = parent.transform
	t.origin.y += 1
	fix_gridmap_hole(t, parent.get_parent().get_parent().get_node("Floors"))
