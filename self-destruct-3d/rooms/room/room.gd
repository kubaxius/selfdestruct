extends Spatial

func _ready():
	get_door_transforms()

func get_door_transforms():
	var transforms = []
	var walls: GridMap = $Walls
	for cell_pos in walls.get_used_cells():
		print(walls.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z))
