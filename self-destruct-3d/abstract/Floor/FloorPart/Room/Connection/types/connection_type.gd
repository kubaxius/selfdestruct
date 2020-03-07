extends State
class_name ConnectionType

func does_connection_match(connection) -> bool:
	if parent.type == connection.type:
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
	# rotates transform 180 degrees along y axis
	t.basis = t.basis.rotated(parent.transform.basis.y, PI)
	t *= room_connection.transform.inverse()
	return [t]

func fix_gridmap_hole(t: Transform, gridmap: GridMap, center_height = true,
					  height_multiplier = 1, copy_rotation_to_tiles = false):
	
	var hole_width: int = parent.hole_width
	var hole_height: int = parent.hole_height
	var tile_id = parent.fixing_tile_id
	
	# move position to sit exactly in center of tile
	if hole_width % 2 == 0:
		t.origin += t.basis.x * 0.5
	if hole_height % 2 == 0:
		t.origin += t.basis.y * 0.5
	t.origin += t.basis.z * 0.5
	
	var gridmap_pos = gridmap.world_to_map(t.origin)
	
	var width_range = Helper.get_centered_range(hole_width)
	var height_range = hole_height
	
	if center_height:
		height_range = Helper.get_centered_range(hole_height)
	
	var top = t.basis.orthonormalized().y
	var right = t.basis.orthonormalized().x
	var orientation = 0
	if copy_rotation_to_tiles:
		orientation = t.basis.get_orthogonal_index()
	
	for h in height_range:
		h = h*height_multiplier
		for w in width_range:
			var current_pos = gridmap_pos + top*h + right*w
			gridmap.set_cell_item(int(round(current_pos.x)), int(round(current_pos.y)), int(round(current_pos.z)), tile_id, orientation)

func fix_hole():
	pass

func connect_room(_connection):
	pass
