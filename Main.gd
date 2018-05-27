extends Node2D

func _ready():
	$Ball.connect("body_entered", self, "ball_collide")
	$GUI/ResetButton.connect("button_down", self, "reset_level")

func ball_collide(other):
	if other.is_in_group("goal"):
		$WinPopup.show()
		print("you win")

func _input(event):
	if event is InputEventMouseMotion:
		$Cannon.set_target(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var proj = preload("res://Projectile.tscn").instance()
			proj.position = $Cannon.position +  Vector2(0,-12)
			add_child(proj)
			proj.apply_impulse(Vector2(0, 0), Vector2($Cannon.power, 0).rotated($Cannon/Barrel.rotation))

func reset_level():
	get_tree().reload_current_scene()