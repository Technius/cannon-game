extends WindowDialog

func _ready():
	$CloseButton.connect("button_down", self, "hide")