extends KinematicBody

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var path_timer = $PathTimer
onready var die_timer = $DieTimer
onready var sprite = $Sprite3D
onready var chatter1 = $Chatter1
onready var chatter2 = $Chatter2
onready var chatter3 = $Chatter3
onready var chatter4 = $Chatter4
onready var chatter5 = $Chatter5
onready var chatters = [
	chatter1,
	chatter2,
	chatter3,
	chatter4,
	chatter5
]

const Plant = preload("res://src/Plant.tscn")
const MOVE_SPEED = 5.0

var player = null
var navigation = null
var world = null
var dead = false
var path = []
var colour = null

signal died

func _ready():
	add_to_group("zombies")
	if player:
		connect("died", player, "_on_Zombie_died")
	anim_player.play("walk")
	$ChatterTimer.start(rand_range(5.0, 30.0))

func set_player(p):
	player = p

func set_navigation(n):
	navigation = n

func set_world(w):
	world = w

func _physics_process(delta):
	if dead:
		return
	if player == null or navigation == null:
		return

	# Create the path to the player
	if path_timer.is_stopped():
		path_timer.start()

	# Walk the path
	var direction = Vector3()
	if path.size() > 0:
		# Go to the nearest/next point on the path
		var destination = path[0]
		direction = destination - translation
		var step_size = delta * MOVE_SPEED
		# Clamp step size if we're near the node
		if step_size > direction.length():
			step_size = direction.length()
			path.remove(0) # we just reached this node
		# Move to the path node
		var col = move_and_collide(direction.normalized() * step_size)
		if col != null:
			if col.get_collider().name == "Player":
				col.get_collider().kill()
		# Look in the direction we're travelling
		direction.y = 0 # only look left/right, not up/down
		if direction:
			var look_at_point = translation + direction.normalized()
			look_at(look_at_point, Vector3.UP)

func kill(c):
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")
	Globals.inc_score(100)
	emit_signal("died")
	die_timer.start()
	self.colour = c

func _on_PathTimer_timeout():
	# Calculate the path to the player
	# Still handles corners slightly weird.
	path = []
	var p = navigation.get_simple_path(translation, player.translation, true)
	# Fix path y translations to keep us above the floor
	for point in p:
		path.append(Vector3(point.x, translation.y, point.z))

func _on_DieTimer_timeout():
	assert(self.colour != null)
	var plant = Plant.instance().setup(self.colour)
	plant.translation = Vector3(self.translation.x, plant.translation.y, self.translation.z)
	if randf() > 0.5:
		plant.get_node("AnimatedSprite3D").flip_h = true
	world.add_child(plant)
	self.hide()

func _on_ChatterTimer_timeout():
	var i = randi() % chatters.size()
	chatters[i].play()
