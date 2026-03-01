extends Control

signal timerOver

var timerTime := 150.0
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
		emit_signal("timerOver")
		set_process(false)
		return

	var minutes := int(timerTime / 60.0)
	var seconds := int(timerTime) % 60
	$Timer.text = "%d:%02d" % [minutes, seconds]
