extends GridMap

const N = 1
const E = 2
const S = 4
const W = 8

var width = 20
var height = 20 # probably better to call this depth, it's the z axis
var spacing = 2 # how many tiles do we need to move to change directions

var erase_fraction = 0.25

var cell_walls = {
	Vector3(0,0,-spacing): N, 
	Vector3(spacing,0,0): E, 
	Vector3(0,0,spacing): S, 
	Vector3(-spacing,0,0): W}

func _ready():
	clear() # clear out all the stuff placed during level design
	if Network.local_player_id == 1:
		randomize()
		make_map_border()
		make_map()
		record_tile_positions()
		rpc("send_ready")

# set the walls of the game space
func make_map_border():
	$Border.resize_border(cell_size.x, width) # assumes square maps
	

# handles populating the map
func make_map():
	make_blank_map()
	make_maze()
	erase_walls()

# handles populating the map
# go through every single value of x,z and set to tile 15
func make_blank_map():
	for x in width:
		for z in height:
			var possible_rotations = [0, 10, 16, 22]
			var building_rotation = possible_rotations[randi()%4]
			var building = pick_building()
			# set the cell tile to the location in each loop
			# set_cell_item(x, 0, z, building, building_rotation) # set cell for non-networked generation
			rpc("place_cell", x, z, building, building_rotation) # set cell for networked generation

func pick_building():
	var chance_of_skyscraper = 1
	var skyscraper = 16
	var possible_buildings = [17, 18, 19, 20, 21, 22, 23, 24]
	var building
	if (randi() %99) +1 <= chance_of_skyscraper:
		building = skyscraper
	else: 
		building = possible_buildings[randi() % possible_buildings.size() - 1]
	return building

# handles checking the data of the neighboring cells during maze generation
func check_neighbors(cell, unvisited):
	# create an array to store cells
	var list = []
	# loop through adjacent cells - for every vector3 direction from current cell
	# if the cell in that direction adjacent to the current cell is on the 'unvisited' list
	# then append that neighboring cell to the list
	for n in cell_walls.keys():
		if cell+n in unvisited:
			list.append(cell+n)
	# return the list of adjacent unvisited cells
	return list

# generate a maze by randomly creating a path through the grid and placing tiles 
# which match existing pathway as well as randomly generated pathways
func make_maze():
	# empty array to store cells which haven't yet been visted
	var unvisited = []
	# empty array to store cells that we're working on right now
	var stack = []
	
	# loop through x axis values between 0 and the total width at an interval of what the spacing is
	for x in range(0, width, spacing):
		# loop through z axis values between 0 and the total height at an interval of what the spacing is
		for z in range(0, height, spacing):
			# add the cell at x,z to the list of unvisited cells
			unvisited.append(Vector3(x,0,z))
	
	# create variable for the cell currently occupied and set it to the origin
	var current = Vector3(0,0,0)
	# erase the value for whatever the current cell is from the list of unvisited tiles
	unvisited.erase(current)
	
	# every time there is an unvisited square, check its neighbors and put them in the list
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		
		# as long as there are neighbors on the list, loop through this
		if neighbors.size() > 0:
			var next
			if current == Vector3(0,0,0):
				next = Vector3(0,0,spacing) # ensures that we always start with the first tile facing south
			else: 
				# choose a random neighbor from the list based on the size of the neighbors list
				next = neighbors[randi() % neighbors.size()]
			
			# if there are unvisited neighbors then keep them in the stack list
			stack.append(current)
			
			# set the direction based on the difference between the chosen neighbor and the current cell
			var dir = next - current
			
			# get the current cell item and subtract whatever is going in that direction
			# if we're going north, subtract 1. if we're going west subtract 8, etc
			var current_walls = min(get_cell_item(current.x, 0, current.z), 15) - cell_walls[dir]
			# current walls are whatever the cell is right now minus the wall in the direction we're going to 
			# same thing in the next one, we're going in and going to remove the opposite wall 
			# (the one we travel through to get there) 
			# cells have adjoining walls removed so they look like they connect smoothly
			var next_walls = min(get_cell_item(next.x, 0, next.z), 15) - cell_walls[-dir]
			
			# set what goes in the current and the next cell of the maze in non-networked generation
			# set_cell_item(current.x, 0, current.z, current_walls, 0)
			# set_cell_item(next.x, 0, next.z, next_walls, 0)
			
			# set what goes in the current and the next cell of the maze in networked generation
			rpc("place_cell", current.x, current.z, current_walls, 0)
			rpc("place_cell", next.x, next.z, next_walls, 0)
			# check for gaps from spacing selection and fill them
			fill_gaps(current, dir)
			
			# now that the route to the next cell is in place, set the next cell as "current"
			current = next
			# remove the current cell from the list of unvisited cells
			unvisited.erase(current)
		
		# remove the current cell from the stack if we're not using it any more
		elif stack:
			current = stack.pop_back()

func fill_gaps(current_cell, dir):
	var tile_type
	for i in range(1, spacing): # range starts at 1 so that if the spacing is set to 1 the loop won't run
		if dir.x > 0: # if we're heading east
			tile_type = 5 # use the e-w road tile, 5
			current_cell.x += 1 # change the value of the current cell 
		elif dir.x < 0:
			tile_type = 5 # use the e-w road tile, 5
			current_cell.x -= 1 # change the value of the current cell 
		elif dir.z > 0:
			tile_type = 10 # use the n-s road tile, 10
			current_cell.z += 1 # change the value of the current cell 
		elif dir.z < 0:
			tile_type = 10 # use the n-s road tile, 10
			current_cell.z -= 1 # change the value of the current cell 
		
		# set_cell_item(current_cell.x, 0, current_cell.z, tile_type, 0) # set cell in non-networked generation
		rpc("place_cell", current_cell.x, current_cell.z, tile_type, 0) # set cell in networked generation

func erase_walls():
	for i in range(width * height * erase_fraction): # get the total no of cells and reduce to the erase_fraction
		var x = int(rand_range(1, (width - 1)/spacing)) * spacing # need to start range at 1 so that there aren't holes in map
		var z = int(rand_range(1, (height - 1)/spacing)) * spacing
		var cell = Vector3(x,0,z) # variable to store cell as func progresses
		var current_cell = get_cell_item(cell.x, cell.y, cell.z)
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		
		if current_cell & cell_walls[neighbor]: # used bitwise and operator to look for adjoining wall
			var walls = current_cell - cell_walls[neighbor]
			walls = clamp(walls, 0, 15)
			var neighbor_walls = get_cell_item((cell + neighbor).x, 0, (cell + neighbor).z) - cell_walls[-neighbor]
			neighbor_walls = clamp(neighbor_walls, 0, 15)
			
			# set cells in non-networked generation
			# set_cell_item(cell.x, 0, cell.z, walls, 0)
			# set_cell_item((cell + neighbor).x, 0, (cell + neighbor).z, neighbor_walls, 0)
			
			# set cells in networked generation
			rpc("place_cell", cell.x, cell.z, walls, 0)
			rpc("place_cell", cell.x + neighbor.x, cell.z + neighbor.z, neighbor_walls, 0)
			fill_gaps(cell, neighbor)

sync func place_cell(x, z, cell, cell_rotation):
	set_cell_item(x, 0, z, cell, cell_rotation)

# create list of which tiles are in which positions after grid has been procedurally generated
func record_tile_positions():
	var tiles = []
	for x in range(0, width):
		for z in range (0, height):
			# set current position as variable within each iteration of loop
			var current_cell = Vector3(x, 0, z)
			# record which tile is at the current position for each loop
			var current_tile_type = get_cell_item(current_cell.x, 0, current_cell.z)
			# if the current tile is 0-15 (i.e. a road segment, not a building), then execute this
			if current_tile_type < 15:
				# append the current cell's Vector3 to the list of tiles
				tiles.append(current_cell)
	# establish the Vector2 map_size according to the width and height of the game map
	var map_size = Vector2(width, height)
	# call generate props according to the array of tiles with road in them and the Vector2 map_size
	$ObjectSpawner.generate_props(tiles, map_size)

# handle notifying host when players are ready
sync func send_ready():
	# if you are the host, run player_ready on your machine
	if Network.local_player_id == 1:
		player_ready()
	# if you're not the host, run player_ready on the host's machine
	else:
		rpc_id(1, "player_ready")

# increments the count of players who are ready to begin play. if this == registered players, runs send_go on host's machine
remote func player_ready():
	Network.ready_players += 1
	if Network.ready_players == Network.players.size():
		rpc("send_go")

# tells host's machine to unpause game once all players are ready to play
sync func send_go():
	get_tree().call_group("GameState", "unpause")
