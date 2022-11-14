extends Node

var x = 0.0
var player = null

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS # exclude from pause

func _input(event):
	if event is InputEventMouseButton:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			# Resume...
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false

func _process(delta):
	if player:
		x += 0.01
		#print(abs(sin(x)))
		player.score_label.set_modulate(Color(abs(sin(x)), abs(cos(x)), abs(tan(x)), 1.0))
		player.score_hint_label.set_modulate(Color(abs(sin(x)), abs(cos(x)), abs(tan(x)), 1.0))
	if Input.is_action_just_pressed("exit"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			pause()
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			get_tree().quit()
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# PAUSE functionality goes here...
	get_tree().paused = true
