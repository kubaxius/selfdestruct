extends RigidBody

var desired_velocity = Vector3()
var desired_altitude = 1.5
 
export(int, 1, 100) var max_speed = 10
export(float, 0.01, 1) var speed_change_step = 0.1
export(float, -1, 1) var ascending = 0


func _integrate_forces(state):
	if desired_velocity != state.linear_velocity:
		accelerate(state)
	keep_altitude(state)
	
func accelerate(state: PhysicsDirectBodyState):
	var velocity = state.linear_velocity
	
	var x = lerp(velocity.x, desired_velocity.x, speed_change_step)
	var z = lerp(velocity.z, desired_velocity.z, speed_change_step)
	velocity = Vector3(x, velocity.y, z)
	
	state.linear_velocity = velocity

func get_altitude():
	var absolute_altitude = global_transform.origin.y
	var floor_level = $RayCast.get_collision_point().y
	return absolute_altitude - floor_level

func keep_altitude(state: PhysicsDirectBodyState):
	if not Helper.compare_floats(desired_altitude, get_altitude(), 0.1):
		var altitude_diff = desired_altitude - get_altitude()
		if altitude_diff > 0:
			state.linear_velocity.y += 9.8 * state.step
		else:
			state.linear_velocity.y -= 9.8 * state.step
	else:
		state.linear_velocity.y = 0
