extends Node2D

var levels = {
	"LevelTest": preload("res://levels/LevelTest.tscn"),
	"Level2": preload("res://levels/Level2.tscn"),
	"Level3": preload("res://levels/Level3.tscn")
}

func _ready():
	get_tree().paused = true
	for l in levels:
		var button = Button.new()
		button.text = l
		button.connect("button_down", self, "on_set_level_button", [l])
		$Menu/Grid.add_child(button)

func on_set_level_button(level):
	$Main.level_scene = levels[level]
	$Menu.visible = false
	$Main.reset_level()
	get_tree().paused = false