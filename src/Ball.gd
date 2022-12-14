extends RigidBody

var colour = null

func setup(_colour):
	self.colour = _colour
	return self

func _ready():
	assert(colour != null)

func _on_Ball_body_entered(body):
	print("COLLIDE", body.name)
	if "Zombie" in body.name:
		body.kill(colour)
	$ExplodeSound.play()
	$CollisionShape.disabled = true
	self.hide()

func _on_ExplodeSound_finished():
	self.queue_free()
