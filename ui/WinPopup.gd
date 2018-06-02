extends WindowDialog

func _ready():
	$Controls/CloseButton.connect("button_down", self, "hide")
	$Controls/LevelSelectButton.connect("button_down", self, "hide")