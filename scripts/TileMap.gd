extends TileMapLayer

var blockMiningProgress := 0.0
var blockPosition: Vector2i = Vector2i.ZERO

var miningTimes := {
	Vector2i(0, 0): 0.25,
	Vector2i(0, 1): 0.4
}

func _ready() -> void:
	Global.connect("bombExploded", bombExploded)

func mineBlock(playerPosition: Vector2, timeMining: float, dir: Vector2i) -> void:
	# Use tile size (so we don't mine the "second block" by accident)
	var tile_h: int = tile_set.tile_size.y

	# A point around the player's feet (tweak 0.5 -> 0.4/0.6 if your pivot isn't centered)
	var feet_cell: Vector2i = local_to_map(playerPosition + Vector2(0, tile_h * 0.1))

	# Mine exactly 1 tile away in the chosen direction
	var tilemapCellPosition: Vector2i = feet_cell + dir

	# Reset progress when switching blocks
	if tilemapCellPosition != blockPosition:
		blockMiningProgress = 0.0
		blockPosition = tilemapCellPosition

	blockMiningProgress += timeMining

	var blockType: Vector2i = get_cell_atlas_coords(blockPosition)
	if blockType == Vector2i(-1, -1):
		return

	# Crack / break using your atlas-coord logic
	if blockType.x % 2 == 0:
		if blockMiningProgress > miningTimes.get(blockType, 999999.0):
			blockMiningProgress = 0. 
			set_cell(tilemapCellPosition, 2, blockType + Vector2i(1, 0))
	else:
		var baseType := blockType - Vector2i(1, 0)
		if blockMiningProgress > miningTimes.get(baseType, 999999.0):
			blockMiningProgress = 0.0
			erase_cell(tilemapCellPosition)

func bombExploded(bombPosition) -> void:
	var tilemapCellPosition = local_to_map(bombPosition)

	for i in range(tilemapCellPosition.x - 3, tilemapCellPosition.x + 3):
		for j in range(tilemapCellPosition.y - 3, tilemapCellPosition.y + 3):
			var distFromCenter = tilemapCellPosition - Vector2i(i, j)
			distFromCenter = distFromCenter.length()

			if randf() > distFromCenter / 4:
				erase_cell(Vector2i(i, j))
