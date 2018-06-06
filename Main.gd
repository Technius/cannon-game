extends Node2D

signal return_level_select

var playing = true

onready var time_label = get_node("TimeLeft")
onready var game_timer = get_node("Timer")

var level = null
export (PackedScene) var level_scene = preload("res://levels/LevelTest.tscn")
var cannon

func _ready():
	assert(level_scene != null)
	level = $LevelContainer/DefaultLevel
	self.reset_level()
	$GUI/Controls/ResetButton.connect("button_down", self, "reset_level")
	$GUI/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LevelBounds.connect("body_entered", self, "on_object_entry")
	$LevelBounds.connect("body_exited", self, "on_object_oob")
	$WinPopup/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LosePopup/Controls/LevelSelectButton.connect("button_down", self, "on_return_level_select")
	$LosePopup/Controls/ResetButton.connect("button_down", self, "reset_level")
	self.set_gui_visible(false)

func _process(delta):
	if game_timer.is_stopped():
		self.lose_level()
	time_label.set_text("%.1f" % game_timer.get_time_left())


func ball_collide(other):
	if other.is_in_group("goal"):
		if self.playing:
			$WinPopup.show()
			self.playing = false
			print("you win")
	elif other.is_in_group("saw"):
		self.lose_level()

func _input(event):
	var cannon_power = cannon.get_power(get_viewport().get_mouse_position())
	if event is InputEventMouseMotion:
		cannon.set_target(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var proj = preload("res://Projectile.tscn").instance()
			proj.position = cannon.position +  Vector2(0,-22)
			level.add_child(proj)
			proj.apply_impulse(Vector2(0, 0), Vector2(cannon_power, 0).rotated(cannon.get_node("Barrel").rotation))

func reset_level():
	$WinPopup.hide()
	$LosePopup.hide()
	if level != null:
		level.queue_free()
	level = level_scene.instance()
	$LevelContainer.add_child(level)
	self.playing = true
	cannon = level.get_node("Cannon")
	level.get_node("Ball").connect("body_entered", self, "ball_collide")
	game_timer.start()
	game_timer.paused = false

# Causes the player to lose if the level is still playing
func lose_level():
	if playing:
		playing = false
		$LosePopup.show()
		game_timer.paused = true
		print("You lose")

# When an object enters the level bounds (e.g. on level start)
func on_object_entry(object):
	if object.is_in_group("bomb"):
		# Set up bomb explosion animation
		object.connect("explode", self, "show_explosion", [object])

# When an object leaves the level bounds
func on_object_oob(object):
	if object.is_in_group("projectile"):
		if level.is_a_parent_of(object):
			level.remove_child(object)
	elif object == level.get_node("Ball"):
		lose_level()

# Adds an explosion animation when a bomb explodes
func show_explosion(object):
	var expl = preload("res://effects/ExplosionEffect.tscn").instance()
	expl.position = object.position
	self.add_child(expl)
	$SFX.play()

func on_return_level_select():
	set_gui_visible(false)
	self.emit_signal("return_level_select")

func set_gui_visible(visible):
	if visible:
		$GUI.show()
	else:
		$GUI.hide()