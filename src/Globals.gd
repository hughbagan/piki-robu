extends Node

var colours = [
	"RED",
	"ORANGE",
	"GREEN",
	"YELLOW",
	"BLUE",
	"PINK",
	"PURPLE"
]

var player = null
var score = 0

func _ready():
	randomize()

func inc_score(num):
	self.score += num
	if (self.score % 5000) == 0 and player:
		player.show_score()
		player.ammo_label_timer.start(1.0)
