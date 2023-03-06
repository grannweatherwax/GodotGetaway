extends Node

var tiles = []
var map_size = Vector2()

var number_of_parked_cars = 100

# handle generation and placement of props in game map
func generate_props(tile_list, size):
	tiles = tile_list
	map_size = size
	place_cars()

# handles returning a randomized list of an appropriate length for prop placement
func random_tile(tile_count):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles

# handles putting the cars as parked props in the scene
func place_cars():
	var tile_list = random_tile(number_of_parked_cars)
	for i in range(number_of_parked_cars):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of cars as needed
			# remote call to spawn cars 
			rpc("spawn_cars", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing cars
		tile_list.pop_front()

# handles spawning the cars
sync func spawn_cars(tile, car_rotation):
	# preload the car scene instance for faster loading
	var car = preload("res://Props/ParkedCars.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	car.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the car instance according to the rotation parameter
	car.rotation_degrees.y = car_rotation
	# add the translated and rotated car instance to the scene on the correct tile
	add_child(car, true)
