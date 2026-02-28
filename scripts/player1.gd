extends CharacterBody2D

@export var isPlayer2 = false

@export var speed: float = 500.0
@export var gravity: float = 2500.0
@export var jump_force: float = -1250.0

var mine_dir: Vector2i = Vector2i.DOWN

var playerNumber = "1"

var heldBomb: Node = null

var lastDirectionMoved = 1

func _ready() -> void:
	if isPlayer2:
		playerNumber = "2"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var input_dir := Input.get_axis(playerNumber + "move_left", playerNumber + "move_right")
	velocity.x = input_dir * speed

	if Input.is_action_just_pressed(playerNumber + "move_up") and (is_on_floor() or is_on_wall()):
		velocity.y = jump_force

	# Update direction (held is fine just to "aim")
	lastDirectionMoved = 0.2 * sign(lastDirectionMoved)

	if Input.is_action_pressed(playerNumber + "move_left"):
		mine_dir = Vector2i.LEFT
		lastDirectionMoved = -1
	elif Input.is_action_pressed(playerNumber + "move_right"):
		mine_dir = Vector2i.RIGHT
		lastDirectionMoved = 1
	elif Input.is_action_pressed(playerNumber + "move_up"):
		mine_dir = Vector2i.UP
	elif Input.is_action_pressed(playerNumber + "move_down"):
		mine_dir = Vector2i.DOWN

	# Spam-only: mine only on JUST PRESSED (one hit per press)
	if (Input.is_action_just_pressed(playerNumber + "move_left") \
	or Input.is_action_just_pressed(playerNumber + "move_right") \
	or Input.is_action_just_pressed(playerNumber + "move_up") \
	or Input.is_action_just_pressed(playerNumber + "move_down")) and heldBomb == null:
		get_parent().get_node("TileMapLayer").mineBlock(global_position, 0.1, mine_dir)

	if Input.is_action_just_pressed("ui_accept") and heldBomb and heldBomb.bombIsThrown == false:
		heldBomb.reparent(get_parent())
		heldBomb.get_node("CollisionShape2D").disabled = false
		heldBomb.freeze = false
		heldBomb.throw(lastDirectionMoved)

		get_tree().create_timer(0.3).connect("timeout", func ():
			heldBomb = null)

	if Global.playerDead1:
		Global.playerDead1 = false
	move_and_slide()

func pickupBomb(bomb):
	if heldBomb == null:
		heldBomb = bomb
	else:
		return false
	bomb.set_deferred("freeze", true)
	bomb.get_node("CollisionShape2D").set_deferred("disabled", true)
	bomb.call_deferred("reparent", self)
	bomb.set_deferred("rotation", 0)
	bomb.set_deferred("position", Vector2(0, -162))
	return true
