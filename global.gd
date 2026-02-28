extends Node

signal bombExploded(bombPosition)
signal getPoints(player, amount)

var p1points = 0
var p2points = 0

var playerDead1 = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player1Dead() -> void:
	playerDead1 = true
	
func player2Dead() -> void:
	pass
