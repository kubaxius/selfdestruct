extends Spatial

var master_player_state = false
var slave_player_state = false

func _on_MasterRoomArea_body_entered(body):
	if body.is_in_group("players"):
		master_player_state = true
		# player just entered door area
		if not slave_player_state:
			get_parent().room.player_entered()
			get_parent().connected_to.room.player_entered()
		

func _on_SlaveRoomArea_body_entered(body):
	if body.is_in_group("players"):
		slave_player_state = true
		# player just entered door area
		if not master_player_state:
			get_parent().room.player_entered()
			get_parent().connected_to.room.player_entered()


func _on_MasterRoomArea_body_exited(body):
	if body.is_in_group("players"):
		master_player_state = false
		# player just exited door area completly
		if not slave_player_state:
			get_parent().connected_to.room.player_exited()


func _on_SlaveRoomArea_body_exited(body):
	if body.is_in_group("players"):
		slave_player_state = false
		# player just exited door area completly
		if not master_player_state:
			if get_parent().master_connection:
				get_parent().room.player_exited()
