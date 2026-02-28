extends TileMapLayer

var blockMiningProgress1 := 0.0
var blockMiningProgress2 := 0.0
var blockPosition1: Vector2i = Vector2i.ZERO
var blockPosition2: Vector2i = Vector2i.ZERO

var miningTimes := {
	Vector2i(0, 0): 0.125,
	Vector2i(0, 1): 0.2
}

func _ready() -> void:
	Global.connect("bombExploded", bombExploded)

func mineBlock(playerPosition: Vector2, timeMining: float, dir: Vector2i, playerNumber) -> void:
	# Use tile size (so we don't mine the "second block" by accident)
	var tile_h: int = tile_set.tile_size.y

	# A point around the player's feet (tweak 0.5 -> 0.4/0.6 if your pivot isn't centered)
	var feet_cell: Vector2i = local_to_map(playerPosition + Vector2(0, tile_h * 0.1))

	# Mine exactly 1 tile away in the chosen direction
	var tilemapCellPosition: Vector2i = feet_cell + dir

	# Reset progress when switching blocks
	if playerNumber == "2":
		if tilemapCellPosition != blockPosition2 and tilemapCellPosition != blockPosition2 + Vector2i(0, -128):
			blockMiningProgress2 = 0.0
			blockPosition2 = tilemapCellPosition
	else:
		if tilemapCellPosition != blockPosition1 and tilemapCellPosition != blockPosition1 + Vector2i(0, -128):
			blockMiningProgress1 = 0.0
			blockPosition1 = tilemapCellPosition


	if playerNumber == "2":
		blockMiningProgress2 += timeMining
	else:
		blockMiningProgress1 += timeMining

	var blockType: Vector2i
	if playerNumber == "2":
		blockType = get_cell_atlas_coords(blockPosition2)
	else:
		blockType = get_cell_atlas_coords(blockPosition1)


	if blockType == Vector2i(-1, -1):
		if playerNumber == "2":
			blockType = get_cell_atlas_coords(blockPosition2 + Vector2i(0, -1))
		else:
			blockType = get_cell_atlas_coords(blockPosition1 + Vector2i(0, -1))
		tilemapCellPosition += Vector2i(0, -1)
		if blockType == Vector2i(-1, -1):
			return

	# Crack / break using your atlas-coord logic
	if blockType.x % 2 == 0:
		if playerNumber == "2":
			if blockMiningProgress2 > miningTimes.get(blockType, 999999.0):
				blockMiningProgress2 = 0. 
				set_cell(tilemapCellPosition, 2, blockType + Vector2i(1, 0))
		else:
			if blockMiningProgress1 > miningTimes.get(blockType, 999999.0):
				blockMiningProgress1 = 0. 
				set_cell(tilemapCellPosition, 2, blockType + Vector2i(1, 0))
	else:
		var baseType := blockType - Vector2i(1, 0)
		if playerNumber == "2":
			if blockMiningProgress2 > miningTimes.get(baseType, 999999.0):
				blockMiningProgress2 = 0.0
				erase_cell(tilemapCellPosition)
				Global.emit_signal("getPoints", playerNumber, blockPosition2.y / 10 + 1)
		else:
			if blockMiningProgress1 > miningTimes.get(baseType, 999999.0):
				blockMiningProgress1 = 0.0
				erase_cell(tilemapCellPosition)
				Global.emit_signal("getPoints", playerNumber, blockPosition1.y / 10 + 1)


func bombExploded(bombPosition, playerWhoThrew) -> void:
	var tilemapCellPosition = local_to_map(bombPosition)

	var erased = 0

	for i in range(-3, 3):
		for j in range(tilemapCellPosition.y - (4 - abs(i)), tilemapCellPosition.y + (4 - abs(i))):
			var coords = Vector2i(tilemapCellPosition.x + i, j)
			if get_cell_source_id(coords) != -1:
				erased += coords.y / 10 + 1
			erase_cell(coords)
	
	Global.emit_signal("getPoints", playerWhoThrew, erased)
