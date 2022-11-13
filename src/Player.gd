extends KinematicBody

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast
onready var reload_timer = $ReloadTimer
onready var score_label = $CanvasLayer/ScoreLabel
onready var score_label_timer = $ScoreLabelTimer
onready var colour_sprites = $CanvasLayer/Control/ColourSprites
onready var camera = $Camera
onready var hands = $Hands
onready var riffs = [
#	$Riff1, # heavy metal
#	$Riff2, # heavy metal
#	$Riff3, # heavy metal
	$Riff4,
	$Riff5,
	$Riff6
]

const MOVE_SPEED = 7
const MOUSE_SENS = 0.3

var BallScene = preload("res://src/Ball.tscn")
var world = null
var ammo = 6
var reload = 0
var colour = 0
var dead = false
var start = false

func _ready():
	anim_player.play("idle")
	yield(get_tree(), "idle_frame") # wait one frame
	get_tree().call_group("zombies", "set_player", self)
	Globals.player = self
	score_label.text = "piki robu"
	score_label.set_margins_preset(score_label.PRESET_CENTER)
	score_label.show()
	PauseManager.player = self
	PauseManager.pause()

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_degrees.y -= MOUSE_SENS * event.relative.x
			rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * MOUSE_SENS, -90, 90)

func _physics_process(delta):
	if dead:
		return
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_just_pressed("ammo_left"):
		colour -= 1
		if colour < 0:
			colour = Globals.colours.size()-1
		colour_sprites.frame = colour
	if Input.is_action_just_pressed("ammo_right"):
		colour += 1
		if colour >= Globals.colours.size():
			colour = 0
		colour_sprites.frame = colour
#	if move_vec != Vector3() and !$WalkSound.is_playing() and $WalkSoundTimer.is_stopped():
#		$WalkSound.play()
#		$WalkSoundTimer.start()
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)

	if Input.is_action_just_pressed("shoot") \
	and reload_timer.is_stopped() \
	and ammo > 0:
#		ammo -= 1
		reload = 0
		anim_player.stop()
		anim_player.play("shoot")

		var ball = BallScene.instance()
		ball.colour = self.colour
		ball.get_node("Sprite3D").texture = \
			colour_sprites.frames.get_frame("default", colour)
		ball.set_global_transform(hands.global_transform)
		ball.apply_central_impulse(hands.global_transform.basis.z * 30 * -1)
		get_parent().add_child(ball)

		if !start:
			score_label.hide()
			$CanvasLayer/Control.show()
			start = true

		reload_timer.start()
		$ThrowSound.play()

func kill():
	if not dead:
		dead = true
		$CollisionShape.disabled = true
		$CanvasLayer/Control.hide()
		world.endgame()

func show_score(score):
	score_label.text = str(score)
	score_label.set_margins_preset(score_label.PRESET_CENTER)
	score_label.show()
	var playing = false
	for riff in riffs:
		if riff.is_playing():
			playing = true
	if not playing:
		randomize()
		riffs[randi() % riffs.size()].play()

func _on_ReloadTimer_timeout():
	reload_timer.stop()
#	print("ready")

func _on_AmmoLabelTimer_timeout():
	score_label.hide()

func _on_Zombie_died():
	pass
