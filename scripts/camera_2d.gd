extends Camera2D

@export var player1: Node2D
@export var player2: Node2D

@export var min_zoom: float = 0.111
@export var max_zoom: float = 10.0
@export var zoom_speed: float = 5.0
@export var margin: float = 800.0

func _process(delta):
	if !player1 or !player2:
		return

	var midpoint = (player1.global_position + player2.global_position) / 2.0
	global_position = global_position.lerp(midpoint, 5.0 * delta)

	var distance = player1.global_position.distance_to(player2.global_position)
	var screen_size = get_viewport_rect().size

	var ratio_x = (distance + margin) / screen_size.x
	var ratio_y = (distance + margin) / screen_size.y
	var ratio = max(ratio_x, ratio_y)

	var target = 1.0 / max(ratio, 0.0001)
	target = clamp(target, min_zoom, max_zoom)

	zoom = zoom.lerp(Vector2(target, target), zoom_speed * delta)
