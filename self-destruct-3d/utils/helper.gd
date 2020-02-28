extends Node
class_name Helper

const FLOAT_EPSILON = 0.00001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

static func parse_json_from_path(path: String):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	var result_json = JSON.parse(text)
	
	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		return(data)
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)

static func reparent_node(node, new_parent):
	if node.get_parent():
		node.get_parent().remove_child(node)
	new_parent.add_child(node)

static func instance_node_from_path(path: String) -> Node:
	var scene_resource = load(path)
	var scene = scene_resource.instance()
	return scene

static func list_files_in_directory(path, with_path: bool = true):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if(with_path):
				file = path+file
			files.append(file)

	dir.list_dir_end()

	return files
