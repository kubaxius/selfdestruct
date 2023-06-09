tool
extends ConnectionType

func _s_tool_processing(delta):
	var parent = get_parent().get_parent()
	var vis = parent.get_node("HoleVisualization")
	vis.visible = parent.show_hole_visualization
	vis.height = parent.hole_height * 2.6
	vis.width = parent.hole_width
	vis.depth = parent.wall_thickness
	vis.translation.y = vis.height/2
	vis.translation.z = vis.depth/2

func fix_hole():
	fix_gridmap_hole(parent.transform, parent.get_parent().get_parent().get_node("Walls"), false, 2, true)
