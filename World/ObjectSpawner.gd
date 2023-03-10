extends Node

var tiles = []
var cafe_spots = []
var map_size = Vector2()

var tile_size = 20
var tile_offset = 10

var number_of_beacons = 20
var number_of_parked_cars = 100
var number_of_billboards = 75
var number_of_traffic_cones = 40
var number_of_hydrants = 50
var number_of_streetlights = 50 # the more lights and shadows we have, the slower the game
var number_of_ramps = 25
var number_of_scaffolding = 30
var number_of_cafes = 20

signal cop_spawn

func _ready():
	set_multiplier()

func set_multiplier():
	number_of_beacons = number_of_beacons * Network.prop_multiplier
	number_of_parked_cars = number_of_parked_cars * Network.prop_multiplier
	number_of_billboards = number_of_billboards * Network.prop_multiplier
	number_of_traffic_cones = number_of_traffic_cones * Network.prop_multiplier
	number_of_hydrants = number_of_hydrants * Network.prop_multiplier
	number_of_streetlights = number_of_streetlights * Network.prop_multiplier # the more lights and shadows we have, the slower the game
	number_of_ramps = number_of_ramps * Network.prop_multiplier
	number_of_scaffolding = number_of_scaffolding * Network.prop_multiplier
	number_of_cafes = number_of_cafes * Network.prop_multiplier

# handle generation and placement of props in game map
func generate_props(tile_list, size, plazas):
	tiles = tile_list
	cafe_spots = plazas
	map_size = size
	place_beacon()
	place_cars()
	place_billboards()
	place_traffic_cones()
	place_hydrants()
	place_streetlights()
	place_scaffolding()
	place_cafes()

# handles returning a randomized list of an appropriate length for prop placement
func random_tile(tile_count):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles

func place_beacon():
	var tile_list = random_tile(number_of_beacons + 1)
	for _i in range(number_of_beacons):
		var tile = tile_list[0]
		rpc("spawn_beacons", tile)
		tile_list.pop_front()
	rpc("spawn_goal", tile_list[0])

sync func spawn_beacons(tile):
	var beacon = preload("res://Beacon/Beacon.tscn").instance()
	beacon.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	add_child(beacon, true)

sync func spawn_goal(tile):
	var goal = preload("res://Beacon/Goal.tscn").instance()
	goal.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	add_child(goal, true)
	emit_signal("cop_spawn", goal.translation)

# handles putting the cars parked as props in the scene
func place_cars():
	var tile_list = random_tile(number_of_parked_cars + number_of_ramps)
	for _i in range(number_of_parked_cars):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.5 # adjustment for height of prop as needed
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
	car.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the prop instance according to the rotation parameter
	car.rotation_degrees.y = car_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(car, true)

# handles putting the dumpster ramps as props in the scene
func place_ramps(tile_list):
	for _i in range(number_of_ramps):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.6 # adjustment for height of prop as needed
			# remote call to spawn prop 
			rpc("spawn_ramps", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing prop
		tile_list.pop_front()

# handles spawning the dumpster ramps
sync func spawn_ramps(tile, ramp_rotation):
	# preload the prop scene instance for faster loading
	var ramp = preload("res://Props/Dumpster/Dumpster.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	ramp.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the prop instance according to the rotation parameter
	ramp.rotation_degrees.y = ramp_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(ramp, true)

# handles putting the billboards in the scene
func place_billboards():
	var tile_list = random_tile(number_of_billboards)
	for _i in range(number_of_billboards):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y #+ 1 # adjustment for height of prop as needed
			# remote call to spawn prop 
			rpc("spawn_billboards", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the billboards
sync func spawn_billboards(tile, billboard_rotation):
	# preload the prop scene instance for faster loading
	var billboard = preload("res://Props/Billboards/Billboard.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	billboard.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the prop instance according to the rotation parameter
	billboard.rotation_degrees.y = billboard_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(billboard, true)

# handles putting the traffic cones in the scene
func place_traffic_cones():
	var tile_list = random_tile(number_of_traffic_cones)
	for _i in range(number_of_traffic_cones):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.5 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_traffic_cones", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the traffic cones
sync func spawn_traffic_cones(tile, cone_rotation):
	# preload the prop scene instance for faster loading
	var traffic_cones = preload("res://Props/TrafficCones/TrafficCones.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	traffic_cones.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the prop instance according to the rotation parameter
	traffic_cones.rotation_degrees.y = cone_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(traffic_cones, true)

# handles putting the hydrants in the scene
func place_hydrants():
	var tile_list = random_tile(number_of_hydrants)
	for _i in range(number_of_hydrants):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.75 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_hydrants", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the hydrants
sync func spawn_hydrants(tile, hydrant_rotation):
	# preload the prop scene instance for faster loading
	var hydrants = preload("res://Props/Hydrant/Hydrant.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	hydrants.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the props instance according to the rotation parameter
	hydrants.rotation_degrees.y = hydrant_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(hydrants, true)

# handles putting the streetlamps in the scene
func place_streetlights():
	var tile_list = random_tile(number_of_streetlights)
	for _i in range(number_of_streetlights):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.75 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_streetlights", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the streetlamps
sync func spawn_streetlights(tile, streetlight_rotation):
	# preload the prop scene instance for faster loading
	var streetlight = preload("res://Props/StreetLight/StreetLight.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	streetlight.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the props instance according to the rotation parameter
	streetlight.rotation_degrees.y = streetlight_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(streetlight, true)

# handles putting the scaffolding in the scene
func place_scaffolding():
	var tile_list = random_tile(number_of_scaffolding)
	for _i in range(number_of_scaffolding):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		# send the tile type we have a look up possible rotations for the props
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation = allowed_rotations[randi() % allowed_rotations.size() -1] * -1
			tile.y = tile.y + 0.5 # adjustment for height of prop spawn point as needed
			# remote call to spawn prop 
			rpc("spawn_scaffolding", tile, tile_rotation)
		# remove the completed tile from the list of tiles for placing props
		tile_list.pop_front()

# handles spawning the scaffolding
sync func spawn_scaffolding(tile, scaffolding_rotation):
	# preload the prop scene instance for faster loading
	var scaffolding = preload("res://Props/Scaffolding/Scaffolding.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	scaffolding.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the props instance according to the rotation parameter
	scaffolding.rotation_degrees.y = scaffolding_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(scaffolding, true)

func place_cafes():
	cafe_spots.shuffle()
	for i in range(number_of_cafes):
		var tile = cafe_spots[i]
		var building_rotation = tile[0]
		var tile_position = Vector3(tile[1], 0.5, tile[2])
		var tile_rotation = 0
		
		if building_rotation == 10:
			tile_rotation = 180
		elif building_rotation == 16:
			tile_rotation = 90
		elif building_rotation == 22:
			tile_rotation = 270
		
		rpc("spawn_cafes", tile_position, tile_rotation)

# handles spawning the scaffolding
sync func spawn_cafes(tile, cafe_rotation):
	# preload the prop scene instance for faster loading
	var cafe = preload("res://Props/Cafe/Cafe.tscn").instance()
	# Vector3 coordinates involve converting to tile size of 20 and then adding 10 to offset origin to center for each
	cafe.translation = Vector3((tile.x * tile_size) + tile_offset, tile.y, (tile.z * tile_size) + tile_offset)
	# rotate the props instance according to the rotation parameter
	cafe.rotation_degrees.y = cafe_rotation
	# add the translated and rotated prop instance to the scene on the correct tile
	add_child(cafe, true)
