extends Node2D

signal return_level_select

var show_win_popup = true

onready var timer = get_node("Timer")
onready var timer_label = get_node("Label")

var level = null
export (PackedScene) var level_scene = preload("res://levels/LevelTest.tscn")
var cannon

func _ready():
	assert(level_scene != null)
	level = $LevelContainer/DefaultLevel
	self.reset_level()
	$GUI/Controls/ResetButton.connect("button_down", self, "reset_level")
	$GUI/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LevelBounds.connect("body_exited", self, "on_object_oob")
	$WinPopup/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LosePopup/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LosePopup/Controls/ResetButton.connect("button_down", self, "reset_level")
	self.set_gui_visible(false)

func _process(delta):
	if int(timer.get_time_left()) == 0:
		timer.stop()
		$LosePopup.show()
	timer_label.set_text(str(int(timer.get_time_left())))

func ball_collide(other):
	if other.is_in_group("goal"):
		if self.show_win_popup:
			$WinPopup.show()
			self.show_win_popup = false
		print("you win")
	elif other.is_in_group("saw"):
		$LosePopup.show()

func _input(event):
	var cannon_power = cannon.get_power(get_viewport().get_mouse_position())
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
	self.show_win_popup = true
	cannon = level.get_node("Cannon")
	level.get_node("Ball").connect("body_entered", self, "ball_collide")
	timer.start()

# When an object leaves the level bounds
func on_object_oob(object):
	if object.is_in_group("projectile"):
		if level.is_a_parent_of(object):
			level.remove_child(object)
	elif object == level.get_node("Ball") and self.show_win_popup:
		print("You lose")
		$LosePopup.show()

func on_return_level_select():
	set_gui_visible(false)
	self.emit_signal("return_level_select")

func set_gui_visible(visible):
	if visible:
		$GUI.show()
	else:
		$GUI.hide()