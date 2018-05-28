extends Node2D
var show_window = true

func _ready():
	$Ball.connect("body_entered", self, "ball_collide")
	$GUI/ResetButton.connect("button_down", self, "reset_level")
	$LevelBounds.connect("body_exited", self, "on_object_oob")

func ball_collide(other):
	if other.is_in_group("goal"):
		if show_window:
			$WinPopup.show()
			show_window = false
		print("you win")

func _input(event):
	var cannon_power = $Cannon.set_speed()
	if event is InputEventMouseMotion:
		$Cannon.set_target(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var proj = preload("res://Projectile.tscn").instance()
			proj.position = $Cannon.position +  Vector2(0,-12)
			add_child(proj)
			proj.apply_impulse(Vector2(0, 0), Vector2(cannon_power, 0).rotated($Cannon/Barrel.rotation))

func reset_level():
	get_tree().reload_current_scene()

# When an object leaves the level bounds
func on_object_oob(object):
	if object.is_in_group("projectile"):
		self.remove_child(object)
	elif object == $Ball:
		print("You lose")