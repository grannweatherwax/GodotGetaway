extends Spatial

# if you don't want the map to be square, this is where to change it! 
# parameters could tile_size_x and tile_count_x and same for z to change it
func resize_border(tile_size, tile_count):
	rpc("make_border", tile_size, tile_count)

# again could have parameters specific to x and z for non square maps
sync func make_border(tile_size, tile_count):
	# wall_size is based on the length of grid map in tiles
	var wall_size = tile_size * tile_count
	# move the walls to the correct position at the borders of the map
	$N_Wall.translation = Vector3(wall_size/2, $N_Wall.height/2, -1)
	$S_Wall.translation = Vector3(wall_size/2, $S_Wall.height/2, wall_size+1)
	$W_Wall.translation = Vector3(-1, $W_Wall.height/2, wall_size/2)
	$E_Wall.translation = Vector3(wall_size+1, $E_Wall.height/2, wall_size/2)
	# resize all of the walls. For non-square maps, this can't be for all children at once
	for child in get_children():
		child.width = wall_size+2 # add 2 in order to ensure that corners are fully covered
		child.use_collision = true
