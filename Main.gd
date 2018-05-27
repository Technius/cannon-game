extends Node2D

func _ready():
	$Ball.connect("body_entered", self, "ball_collide")

func ball_collide(other):
	if other.is_in_group("goal"):
		print("you win")

func _input(event):
	if event is InputEventMouseMotion:
		$Cannon.set_target(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var proj = preload("res://Projectile.tscn").instance()
			proj.position = $Cannon.position
			add_child(proj)
			proj.apply_impulse(Vector2(0, 0), Vector2(200, 0).rotated($Cannon/Barrel.rotation))
