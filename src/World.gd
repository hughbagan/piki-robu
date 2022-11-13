extends Spatial

onready var navigation = $Navigation
onready var player = $Player
onready var skycam = $SkyCamera
onready var translation_tween = $TranslationTween
onready var transform_tween = $TransformTween
onready var rotation_tween = $RotationTween

var done = false

func _ready():
	# Mouse invisible and stuck to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	get_tree().call_group("zombies", "set_navigation", navigation)
	get_tree().call_group("spawners", "set_navigation", navigation)
	get_tree().call_group("spawners", "set_player", player)
	get_tree().call_group("spawners", "set_world", self)
	player.world = self

func endgame():
	# Total score
	var plants = get_tree().get_nodes_in_group("plants")
	var colours = []
	for p in plants:
		if (not p.colour in colours) and p.colour != null:
			colours.append(p.colour)
	print("colours ", colours)
	Globals.score *= colours.size()-1
	if Globals.score < 0:
		Globals.score = 0
	print(Globals.score)
	player.show_score()

	var TWEEN_TIME = 5.0
	translation_tween.interpolate_property(
		player.camera, "translation",
		player.camera.translation,
		skycam.translation,
		TWEEN_TIME,
		translation_tween.TRANS_LINEAR,
		translation_tween.EASE_IN_OUT
		)
	transform_tween.interpolate_property(
		player.camera, "transform",
		player.camera.transform,
		skycam.transform,
		TWEEN_TIME,
		transform_tween.TRANS_LINEAR,
		transform_tween.EASE_IN_OUT
	)
	rotation_tween.interpolate_property(
		player.camera, "rotation_degrees",
		player.camera.rotation_degrees,
		skycam.rotation_degrees,
		TWEEN_TIME,
		rotation_tween.TRANS_LINEAR,
		rotation_tween.EASE_IN_OUT
	)
	translation_tween.start()
	transform_tween.start()
	rotation_tween.start()

func _on_TranslationTween_tween_completed(object, key):
	#PauseManager.pause()
	done = true
	print(skycam.translation)
	print(skycam.transform)
	print(skycam.rotation_degrees)

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and done:
		if event.pressed:
			get_tree().reload_current_scene()
