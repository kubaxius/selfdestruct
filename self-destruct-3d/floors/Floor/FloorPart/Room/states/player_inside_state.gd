extends "res://floors/Floor/FloorPart/Room/states/room_state.gd"

func _s_init():
	parent.get_node("Ceilings").fade_out()
	parent.emit_signal("player_entered")

func _s_exit():
	parent.get_node("Ceilings").fade_in()
	parent.emit_signal("player_exited")
