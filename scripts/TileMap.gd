extends TileMapLayer

var blockMiningProgress = 0
var blockPosition = Vector2.ZERO

var miningTimes = {
	Vector2(7, 4): 1
}

func mineBlock(playerPosition, timeMining):
	# Get tile under player
	var tilemapCellPosition = local_to_map(playerPosition - Vector2(0, 128))

	if tilemapCellPosition != playerPosition:
		blockMiningProgress = 0
		blockPosition = tilemapCellPosition
	blockMiningProgress += timeMining
	
	var blockType = get_cell_atlas_coords(tilemapCellPosition)

	print("This cell takes " + miningTimes[blockType] + " to mine")
	if blockMiningProgress > miningTimes[blockType]:
		blockMiningProgress = 0
		erase_cell(tilemapCellPosition)
