extends Node2D

var levels = {
	"LevelTest": preload("res://levels/LevelTest.tscn"),
	"Level2": preload("res://levels/Level2.tscn"),
	"Level3": preload("res://levels/Level3.tscn"),
	"Level4": preload("res://levels/Level4.tscn"),
	"Level5": preload("res://levels/Level5.tscn")
}

func _ready():
	get_tree().paused = true
	for l in levels:
		var button = Button.new()
		button.text = l
		button.connect("button_down", self, "on_set_level_button", [l])
		$Menu/Grid.add_child(button)
	$Main.connect("return_level_select", self, "on_return_level_select")

func on_set_level_button(level):
	$Main.level_scene = levels[level]
	$Menu.visible = false
	$Main.reset_level()
	$Main.set_gui_visible(true)
	get_tree().paused = false

func on_return_level_select():
	get_tree().paused = true
	$Menu.visible = true