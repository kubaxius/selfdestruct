tool
extends ConnectionType

func _s_tool_processing(delta):
	var parent = get_parent().get_parent()
	var vis = parent.get_node("HoleVisualization")
	vis.visible = parent.show_hole_visualization
	vis.height = parent.hole_height
	vis.width = parent.hole_width
	vis.depth = parent.wall_thickness
	vis.translation.y = 0
	vis.translation.z = vis.depth/2

func does_connection_match(connection) -> bool:
	if connection.type == parent.ConnectionType.TRAP_DOOR_CEILING:
		if parent.hole_width == connection.hole_width:
			if parent.hole_height == connection.hole_height:
				return true
	return false

func fix_hole():
	var t = parent.transform
	t.origin.y += 1
	fix_gridmap_hole(t, parent.get_parent().get_parent().get_node("Floors"))
