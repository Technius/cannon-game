extends Node2D

export (float) var min_rotation = PI # Clockwise, from 0 to pi
export (float) var max_rotation = PI # Counterclockwise, from 0 to pi
export (float) var power_factor = 1
var mouse_cannon = Vector2 (0,0)

var aim_angle = min_rotation

func _ready():
	pass

func set_target(target):
	aim_angle = clamp(self.position.angle_to_point(target), -self.min_rotation, self.max_rotation) - PI
	$Barrel.rotation = aim_angle
	
	
func set_speed():
	mouse_cannon = get_viewport().get_mouse_position()
	# mouse_cannon.x = (get_viewport().self.position.x - get_viewport().get_mouse_position().x)
	# mouse_cannon.y = (get_viewport().self.position.y - get_viewport().get_mouse_position().y)
	return position.distance_to(mouse_cannon)*power_factor
	