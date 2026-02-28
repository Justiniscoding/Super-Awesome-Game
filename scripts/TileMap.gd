extends TileMapLayer

var blockMiningProgress = 0
var blockPosition = Vector2i.ZERO

var miningTimes = {
	Vector2i(7, 4): 1,
	Vector2i(7, 5): 1
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

	if blockMiningProgress > miningTimes[blockType]:
		blockMiningProgress = 0
		erase_cell(tilemapCellPosition)
