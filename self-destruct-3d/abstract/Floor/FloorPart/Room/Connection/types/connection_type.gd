extends State
class_name ConnectionType

func does_connection_match(connection) -> bool:
	if parent.type == connection.type:
		if parent.hole_width == connection.hole_width:
			if parent.hole_height == connection.hole_height:
				return true
	return false

func fill_gridmap_rect(gridmap: GridMap, gridmap_pos: Vector3, tile_id: int,
					   width: int, height: int, basis: Basis):
	
	var width_range = Helper.get_centered_range(width)
	var height_range = Helper.get_centered_range(height)
	
	var top = basis.orthonormalized().y
	var right = basis.orthonormalized().x
	var orientation = basis.get_orthogonal_index()
	gridmap.set_cell_item(0, 0, 0, -1)
	
	for h in height_range:
		for w in width_range:
			var current_pos = gridmap_pos + top*h + right*w
			gridmap.set_cell_item(round(current_pos.x), round(current_pos.y), round(current_pos.z), tile_id, orientation)

func fix_gridmap_hole(gridmap: GridMap):
	var hole_width: int = parent.hole_width
	var hole_height: int = parent.hole_height
	var fixing_tile_id = parent.fixing_tile_id
	var t = parent.transform
	
	t.origin += t.basis.x * 0.5
	t.origin += t.basis.y * 0.5
	t.origin += t.basis.z * 0.5
	
	var gridmap_pos = gridmap.world_to_map(t.origin)
	var orientation = t.basis.get_orthogonal_index()
	
	fill_gridmap_rect(gridmap, gridmap_pos, fixing_tile_id, hole_width, hole_height, t.basis)

