extends CharacterBody2D

@export var tilemap: PackedScene

@export var speed: float = 350.0
@export var gravity: float = 2500.0
@export var jump_force: float = -900.0

var restartPosition = Vector2(250, 250)

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# left and right
	var input_dir := Input.get_axis("1move_left", "1move_right")
	velocity.x = input_dir * speed
	
	# jumpy
	if Input.is_action_just_pressed("1move_up") and is_on_floor():
		velocity.y = jump_force

	# mine
	if is_on_floor() and Input.is_action_pressed("1move_down"):
		get_parent().get_node("TileMapLayer").mineBlock(position, delta)
		
	if Global.playerDead1:
		position = restartPosition
		Global.playerDead1 = false
	move_and_slide()
