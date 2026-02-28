extends Node

signal bombExploded(bombPosition, player)
signal getPoints(player, amount)
signal scoresChanged

var p1points = 0
var p2points = 0

func changePlayerScore(player, amount):
	if player == "2":
		p2points += amount
		emit_signal("scoresChanged")
		return
	p1points += amount
	emit_signal("scoresChanged")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("getPoints", changePlayerScore)
