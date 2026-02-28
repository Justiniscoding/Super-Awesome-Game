extends Node2D

@onready var play_button = $play
@onready var label = $play/Label
@onready var bomb = $play/bomb
@onready var exploding = $exploder

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_play_pressed()
		set_process(false)

func _on_play_pressed() -> void:
	play_button.disabled = true
	label.text = ""

	bomb.play("Fuse")
	await bomb.animation_finished

	await explode()

	get_tree().change_scene_to_file("res://scenes/game.tscn")


func explode() -> void:
	exploding.play()
	bomb.play("Explosion")
	bomb.scale = Vector2.ONE

	var tween = create_tween()
	tween.tween_property(bomb, "scale", Vector2(18, 18), 0.8)
	await tween.finished

	await exploding.finished
	
