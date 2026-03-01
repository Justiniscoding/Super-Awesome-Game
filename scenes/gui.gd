extends Control

signal timerOver

var timerTime := 151.0
var _done := false

func updateScores() -> void:
	$"P1 Score".text = str(Global.p1points)
	$"P2 Score".text = str(Global.p2points)

func _ready() -> void:
	Global.connect("scoresChanged", Callable(self, "updateScores"))
	connect("timerOver", Callable(Global, "_on_timer_over"))
	updateScores()

	var tween = get_tree().create_tween()
	tween.tween_property($Timer, "modulate", Color(1.0, 0.0, 0.0), timerTime)

func _process(delta: float) -> void:
	if _done:
		return

	timerTime -= delta
	if timerTime <= 0.0:
		timerTime = 0.0
		_done = true
		get_parent().get_parent().get_node("player2").set_process(false)
		get_parent().get_parent().get_node("player2").set_physics_process(false)
		get_parent().get_parent().get_node("player").set_process(false)
		get_parent().get_parent().get_node("player").set_physics_process(false)
		set_process(false)

		var tween = get_tree().create_tween()

		var labelText = ""

		tween.tween_property(get_parent().get_node("Game Over/bg2"), "position", Vector2(576,324), 1.0)
		tween.tween_property(get_parent().get_node("Game Over/Label"), "position", Vector2(0, 0), 1.0)

		if Global.p1points > Global.p2points:
			labelText = "P1 Wins!"
			tween.tween_property(get_parent().get_node("Game Over/Player 1"), "position", Vector2(1026, 250), 1.0)
		elif Global.p2points > Global.p1points:
			labelText = "P2 Wins!"
			tween.tween_property(get_parent().get_node("Game Over/Player 2"), "position", Vector2(138, 250), 1.0)
		else:
			labelText = "It's a tie!"
			tween.tween_property(get_parent().get_node("Game Over/Player 1"), "position", Vector2(1026, 250), 1.0)
			tween.tween_property(get_parent().get_node("Game Over/Player 2"), "position", Vector2(138, 250), 1.0)

		get_parent().get_node("Game Over/Label").text = labelText

		tween.play()

		get_tree().create_timer(8.0).connect("timeout", func():
			get_tree().reload_current_scene())
		return

	var minutes := int(timerTime / 60.0)
	var seconds := int(timerTime) % 60
	$Timer.text = "%d:%02d" % [minutes, seconds]
