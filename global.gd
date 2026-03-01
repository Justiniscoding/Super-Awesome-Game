extends Node

signal bombExploded(bombPosition, player)
signal getPoints(player, amount)
signal scoresChanged

var p1points = 0
var p2points = 0

func changePlayerScore(player, amount):
	if player == "2":
		if p2points + amount >= 0:
			p2points += amount
		emit_signal("scoresChanged")
		return

	if p1points + amount >= 0:
		p1points += amount
		emit_signal("scoresChanged")

func _ready() -> void:
	connect("getPoints", Callable(self, "changePlayerScore"))

func _on_timer_over() -> void:
	print("Timer is over!")
	if p1points > p2points:
		get_tree().change_scene_to_file("res://scenes/p1win.tscn")
	elif p1points==p2points:
		get_tree().change_scene_to_file("res://scenes/draw.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/p2win.tscn")
