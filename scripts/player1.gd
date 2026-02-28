extends CharacterBody2D

@export var speed: float = 500.0
@export var gravity: float = 2500.0
@export var jump_force: float = -1250.0

var mine_dir: Vector2i = Vector2i.DOWN

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var input_dir := Input.get_axis("1move_left", "1move_right")
	velocity.x = input_dir * speed

	if Input.is_action_just_pressed("1move_up") and (is_on_floor() or is_on_wall()):
		velocity.y = jump_force

	# Update direction (held is fine just to "aim")
	if Input.is_action_pressed("1move_left"):
		mine_dir = Vector2i.LEFT
	elif Input.is_action_pressed("1move_right"):
		mine_dir = Vector2i.RIGHT
	elif Input.is_action_pressed("1move_up"):
		mine_dir = Vector2i.UP
	elif Input.is_action_pressed("1move_down"):
		mine_dir = Vector2i.DOWN

	# Spam-only: mine only on JUST PRESSED (one hit per press)
	if Input.is_action_just_pressed("1move_left") \
	or Input.is_action_just_pressed("1move_right") \
	or Input.is_action_just_pressed("1move_up") \
	or Input.is_action_just_pressed("1move_down"):
		get_parent().get_node("TileMapLayer").mineBlock(global_position, 0.1, mine_dir)

	if Global.playerDead1:
		Global.playerDead1 = false
	move_and_slide()
