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

const SCORE_MULT = 10000
var player = null
var score = 0

func _ready():
	randomize()

func inc_score(num):
	# tell the player if we're passing a score multiple
	if (floor((self.score+num)/SCORE_MULT) > floor(self.score/SCORE_MULT)):
		if player:
			player.show_score(floor((self.score+num)/SCORE_MULT) * SCORE_MULT)
			player.score_label_timer.start()
	self.score += num
