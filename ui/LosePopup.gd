extends WindowDialog

func _ready():
	$Controls/ResetButton.connect("button_down", self, "hide")
	$Controls/LevelSelectButton.connect("button_down", self, "hide")