extends Control

var timerTime = 181.0

func updateScores() -> void:
	$"P1 Score".text = str(Global.p1points) 
	$"P2 Score".text = str(Global.p2points)

func _ready() -> void:
	Global.connect("scoresChanged", updateScores)

func _process(delta) -> void:
	timerTime -= delta

	var minutes = floor(timerTime / 60)
	var seconds = str(int(timerTime - (minutes * 60)))
	if len(seconds) == 1:
		seconds = "0" + seconds
	$Timer.text = str(int(minutes)) + ":" +seconds
