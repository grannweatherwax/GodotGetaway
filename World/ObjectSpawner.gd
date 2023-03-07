extends Node

var tiles = []
var map_size = Vector2()

var number_of_parked_cars = 100
var number_of_billboards = 75
var number_of_traffic_cones = 40
var number_of_hydrants = 50
var number_of_streetlights = 50 # the more lights and shadows we have, the slower the game
var number_of_ramps = 25

# handle generation and placement of props in game map
func generate_props(tile_list, size):
	tiles = tile_list
	map_size = size
	place_cars()
	place_billboards()
	place_traffic_cones()
	place_hydrants()
	place_streetlights()

# handles returning a randomized list of an appropriate length for prop placement
func random_tile(tile_count):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles

# handles putting the cars parked as props in the scene
func place_cars():
	var tile_list = random_tile(number_of_parked_cars + number_of_ramps)
	for i in range(number_of_parked_cars):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop as needed
			# remote call to spawn prop 
			rpc("spawn_cars", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing prop
		tile_list.pop_front()
	# call the place ramp function and send the list of remaining available tiles to it
	place_ramps(tile_list)

# handles spawning the cars
sync func spawn_cars(tile, car_rotation):
	# preload the prop scene instance for faster loading
	var car = preload("res://Props/ParkedCars.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	car.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the prop instance according to the rotation parameter
	car.rotation_degrees.y = car_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(car, true)

# handles putting the dumpster ramps as props in the scene
func place_ramps(tile_list):
	for i in range(number_of_ramps):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop as needed
			# remote call to spawn prop 
			rpc("spawn_ramps", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing prop
		tile_list.pop_front()

# handles spawning the dumpster ramps
sync func spawn_ramps(tile, ramp_rotation):
	# preload the prop scene instance for faster loading
	var ramp = preload("res://Props/Dumpster/Dumpster.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	ramp.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the prop instance according to the rotation parameter
	ramp.rotation_degrees.y = ramp_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(ramp, true)

# handles putting the billboards in the scene
func place_billboards():
	var tile_list = random_tile(number_of_billboards)
	for i in range(number_of_billboards):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop as needed
			# remote call to spawn prop 
			rpc("spawn_billboards", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the billboards
sync func spawn_billboards(tile, billboard_rotation):
	# preload the prop scene instance for faster loading
	var billboard = preload("res://Props/Billboards/Billboard.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	billboard.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the prop instance according to the rotation parameter
	billboard.rotation_degrees.y = billboard_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(billboard, true)

# handles putting the traffic cones in the scene
func place_traffic_cones():
	var tile_list = random_tile(number_of_traffic_cones)
	for i in range(number_of_traffic_cones):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_traffic_cones", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the traffic cones
sync func spawn_traffic_cones(tile, cone_rotation):
	# preload the prop scene instance for faster loading
	var traffic_cones = preload("res://Props/TrafficCones/TrafficCones.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	traffic_cones.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the prop instance according to the rotation parameter
	traffic_cones.rotation_degrees.y = cone_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(traffic_cones, true)

# handles putting the hydrants in the scene
func place_hydrants():
	var tile_list = random_tile(number_of_hydrants)
	for i in range(number_of_hydrants):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_hydrants", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the hydrants
sync func spawn_hydrants(tile, hydrant_rotation):
	# preload the prop scene instance for faster loading
	var hydrants = preload("res://Props/Hydrant/Hydrant.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	hydrants.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the props instance according to the rotation parameter
	hydrants.rotation_degrees.y = hydrant_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(hydrants, true)

# handles putting the streetlamps in the scene
func place_streetlights():
	var tile_list = random_tile(number_of_streetlights)
	for i in range(number_of_streetlights):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 1 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_streetlights", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the streetlamps
sync func spawn_streetlights(tile, streetlight_rotation):
	# preload the prop scene instance for faster loading
	var streetlight = preload("res://Props/StreetLight/StreetLight.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	streetlight.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	# rotate the props instance according to the rotation parameter
	streetlight.rotation_degrees.y = streetlight_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(streetlight, true)
