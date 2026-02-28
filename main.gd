extends Node2D

func _ready() -> void:
	$Button.connect("pressed", playGame)

func playGame() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
