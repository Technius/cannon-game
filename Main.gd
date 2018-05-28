extends Node2D

var show_window = true

var level = null
export (PackedScene) var level_scene = preload("res://levels/LevelTest.tscn")
var cannon

func _ready():
	assert(level_scene != null)
	level = $LevelContainer/DefaultLevel
	self.reset_level()
	$GUI/ResetButton.connect("button_down", self, "reset_level")
	$LevelBounds.connect("body_exited", self, "on_object_oob")

func ball_collide(other):
	if other.is_in_group("goal"):
		if show_window:
			$WinPopup.show()
			show_window = false
		print("you win")

func _input(event):
	var cannon_power = cannon.set_speed()
	if event is InputEventMouseMotion:
		cannon.set_target(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var proj = preload("res://Projectile.tscn").instance()
			proj.position = cannon.position +  Vector2(0,-12)
			level.add_child(proj)
			proj.apply_impulse(Vector2(0, 0), Vector2(cannon_power, 0).rotated(cannon.get_node("Barrel").rotation))

func reset_level():
	$WinPopup.hide()
	if level != null:
		level.queue_free()
	level = level_scene.instance()
	$LevelContainer.add_child(level)

	cannon = level.get_node("Cannon")
	level.get_node("Ball").connect("body_entered", self, "ball_collide")

# When an object leaves the level bounds
func on_object_oob(object):
	if object.is_in_group("projectile"):
		if level.is_a_parent_of(object):
			level.remove_child(object)
	elif object == level.get_node("Ball"):
		print("You lose")