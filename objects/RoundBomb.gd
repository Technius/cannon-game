extends RigidBody2D

signal explode

export (float) var threshold = 100.0
export (float) var power = 1000.0

func _ready():
	self.connect("body_entered", self, "on_body_entered")

func on_body_entered(other):
	var impulse
	if other is RigidBody2D:
		impulse = other.mass * other.linear_velocity.length() - self.mass * self.linear_velocity.length()
	else:
		impulse = self.mass * self.linear_velocity.length_squared()
	if abs(impulse) > threshold:
		explode()

func explode():
	self.emit_signal("explode")
	var area_circle = $ExplosionArea.shape_owner_get_shape(0, 0)
	var space_state = self.get_world_2d().direct_space_state
	for b in $ExplosionArea.get_overlapping_bodies():
		if not b.is_in_group("level_object") or not b is RigidBody2D:
			continue
		var collide_info = space_state.intersect_ray(self.global_transform.origin, b.global_transform.origin)
		if collide_info:
			var direction = (b.position - self.position).normalized()
			var scale = 1 - self.position.distance_squared_to(b.position) / (area_circle.radius * area_circle.radius)
			print(scale)
			var impulse = power * scale * direction
			b.apply_impulse(Vector2(0, 0), impulse)
	self.queue_free()