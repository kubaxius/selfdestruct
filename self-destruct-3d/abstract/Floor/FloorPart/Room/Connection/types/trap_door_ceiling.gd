extends ConnectionType

func does_connection_match(connection) -> bool:
	if connection.type == parent.ConnectionType.TRAP_DOOR_FLOOR:
		if parent.hole_width == connection.hole_width:
			if parent.hole_height == connection.hole_height:
				return true
	return false
