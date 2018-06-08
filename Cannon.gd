extends Node2D

export (float) var min_rotation = PI # Clockwise, from 0 to pi
export (float) var max_rotation = PI # Counterclockwise, from 0 to pi
export (float) var power_factor = 1
export (float) var max_power = 1000.0

var aim_angle = min_rotation

func set_target(target):
	aim_angle = clamp(self.position.angle_to_point(target), -self.min_rotation, self.max_rotation) - PI
	$Barrel.rotation = aim_angle
	
	
func get_power(target_pos):
	return min(position.distance_to(target_pos) * power_factor, max_power)