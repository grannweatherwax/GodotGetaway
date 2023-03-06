extends Node

# creates a list of which rotations are allowed based on tile type
func lookup_rotation(tile):
	var rotations = []
	match tile: 
		0: # you are not allowed to place a car if the tile is this one
			rotations = null
		1, 3, 5, 7, 9, 11, 13: # you're allowed to have a rotation of 0 if the tile is any of these
			rotations.append(0)
		2, 3, 6, 7, 10, 11, 14:
			rotations.append(90) # you're allowed to have a rotation of 90 if the tile is any of these
		4, 5, 6, 7, 12, 13, 14:
			rotations.append(180) # you're allowed to have a rotation of 180 if the tile is any of these
		8, 9, 10, 11, 12, 13, 14:
			rotations.append(270) # you're allowed to have a rotation of 270 if the tile is any of these
	return rotations
