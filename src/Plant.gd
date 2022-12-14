extends Area

onready var sprite = $AnimatedSprite3D

var colour = null

func setup(_colour): # Note: not a real constructor or _init(). It's fake.
	self.colour = _colour
	return self

func _ready():
	assert(self.colour != null)
	sprite.frame = self.colour
	self.add_to_group("plants")
	$AnimatedSprite3D.scale = Vector3(1, 0, 1)
	$Tween.interpolate_property(
		$AnimatedSprite3D, "scale",
		Vector3(1, 0, 1),
		Vector3(1, 1, 1),
		1.0,
		$Tween.TRANS_QUAD,
		$Tween.EASE_OUT
		)
	$Tween.start()

func _on_Plant_area_entered(area):
	if "Plant" in area.name:
		var plants = 0
		for a in get_overlapping_areas():
			if "Plant" in a.name:
				if a.colour == self.colour:
					plants += 1
					print(area, " entered")
		Globals.inc_score(plants*100)
