extends ConnectionType


func fix_hole():
	fix_gridmap_hole(parent.get_parent().get_parent().get_node("Walls"))
