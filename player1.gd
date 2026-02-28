extends CharacterBody2D

@export var speed: float = 200.0
@export var gravity: float = 900.0
@export var jump_force: float = -400.0

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
	
	move_and_slide()
