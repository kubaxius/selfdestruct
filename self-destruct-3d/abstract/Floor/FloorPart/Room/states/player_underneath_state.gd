extends "res://abstract/Floor/FloorPart/Room/states/room_state.gd"

func _s_init():
	parent.fade_out()

func _s_exit():
	parent.fade_in()
