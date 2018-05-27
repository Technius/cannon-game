extends Node2D

export (float) var min_rotation = PI # Clockwise, from 0 to pi
export (float) var max_rotation = PI # Counterclockwise, from 0 to pi
export (float) var power = 300

var aim_angle = min_rotation

func _ready():
	pass

func set_target(target):
	aim_angle = clamp(self.position.angle_to_point(target), -self.min_rotation, self.max_rotation) - PI
	$Barrel.rotation = aim_angle