extends TileMapLayer

var blockMiningProgress = 0
var blockPosition = Vector2i.ZERO

var miningTimes = {
	Vector2i(0, 0): 0.5,
	Vector2i(0, 1): 0.7
}

func mineBlock(playerPosition, timeMining):
	# Get tile under player
	var tilemapCellPosition = local_to_map(playerPosition + Vector2(0, 128))

	if tilemapCellPosition != blockPosition:
		blockMiningProgress = 0
		blockPosition = tilemapCellPosition
	blockMiningProgress += timeMining
	
	var blockType = get_cell_atlas_coords(blockPosition)

	if blockType == Vector2i(-1, -1):
		return

	if blockType.x % 2 == 0:
		if blockMiningProgress > miningTimes[blockType]:
			blockMiningProgress = 0
			print(blockType)
			print(blockType + Vector2i(1, 0))
			set_cell(tilemapCellPosition, 0, blockType + Vector2i(1, 0))
			# erase_cell(tilemapCellPosition)
	
