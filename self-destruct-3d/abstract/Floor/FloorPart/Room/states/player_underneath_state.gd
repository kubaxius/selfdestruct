extends "res://abstract/Floor/FloorPart/Room/states/room_state.gd"

func _s_init():
	parent.fade_out()

func _s_process(_delta):
	var players_array = get_tree().get_nodes_in_group("players")
	if players_array.size() > 0:
		var player_altitude = players_array[0].global_transform.origin.y
		if parent.global_transform.origin.y < player_altitude:
			parent.get_node("StateMachine").current_state = "PlayerUnderneath"

func _s_exit():
	parent.fade_in()
