extends Control

func updateScores() -> void:
	$"P1 Score".text = str(Global.p1points) 
	$"P2 Score".text = str(Global.p2points)

func _ready() -> void:
	Global.connect("scoresChanged", updateScores)
