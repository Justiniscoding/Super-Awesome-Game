extends Control

var timerTime = 181.0

func updateScores() -> void:
	$"P1 Score".text = str(Global.p1points) 
	$"P2 Score".text = str(Global.p2points)

func _ready() -> void:
	Global.connect("scoresChanged", updateScores)

	var tween = get_tree().create_tween()
	tween.tween_property($Timer, "modulate", Color(1.0, 0.0, 0.0), 181.0)
	tween.play()

func _process(delta) -> void:
	timerTime -= delta

	var minutes = floor(timerTime / 60)
	var seconds =int(timerTime - (minutes * 60))

	seconds = str(seconds)
	if len(seconds) == 1:
		seconds = "0" + seconds
	$Timer.text = str(int(minutes)) + ":" +seconds
