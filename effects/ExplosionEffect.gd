extends Sprite

func _ready():
	# Delete self when explode animation is finished
	$AnimationPlayer.connect("animation_finished", self, "remove_self")

func remove_self(ignored):
	self.queue_free()