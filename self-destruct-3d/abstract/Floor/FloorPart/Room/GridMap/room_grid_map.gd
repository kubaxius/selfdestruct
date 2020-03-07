extends GridMap
class_name RoomGridMap

export(float, 0, 1) var visibility = 1 setget set_visibility

var materials

func set_visibility(value):
	if typeof(materials) == TYPE_DICTIONARY:
		for material_name in materials:
			if material_name != "Sides":
				if value < 1:
					materials[material_name].flags_transparent = true
					materials[material_name].albedo_color.a = value
				else:
					materials[material_name].flags_transparent = false
	visibility = value

func make_meshes_unique():
	for id in mesh_library.get_item_list():
		mesh_library.set_item_mesh(id, mesh_library.get_item_mesh(id).duplicate())

func make_materials_unique():
	var materials = {}
	for id in mesh_library.get_item_list():
		var mesh = mesh_library.get_item_mesh(id)
		for i in mesh.get_surface_count():
			var res_name = mesh.surface_get_material(i).resource_name
			if not materials.has(res_name):
				materials[res_name] = mesh.surface_get_material(i).duplicate()
			mesh.surface_set_material(i, materials[res_name])

func get_materials() -> Dictionary:
	var materials = {}
	for id in mesh_library.get_item_list():
		var mesh = mesh_library.get_item_mesh(id)
		for i in mesh.get_surface_count():
			var res_name = mesh.surface_get_material(i).resource_name
			if not materials.has(res_name):
				materials[res_name] = mesh.surface_get_material(i)
	return materials

func fade_out():
	$AnimationPlayer.play("fade_out")

func fade_in():
	$AnimationPlayer.play("fade_in")

func _ready():
	make_meshes_unique()
	make_materials_unique()
	materials = get_materials()
