extends State

func _s_init():
	parent.emit_signal("generation_failed")
