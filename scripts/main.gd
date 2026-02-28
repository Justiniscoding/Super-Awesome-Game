extends Node2D

func _ready() -> void:
	$play.connect("pressed", playGame)

func playGame() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
