extends Camera

var East_West_line
var North_South_line

var tile_size = 20
var tile_offset = 10

func _ready():
	make_neighborhoods()

func _physics_process(delta):
	# if East_West_line has been defined, manage the audiobus levels
	if East_West_line != null:
		manage_Bus_levels()

# establish lines to define map quadrants
func make_neighborhoods():
	East_West_line = (Network.city_size.x * tile_size) / 2
	North_South_line = (Network.city_size.y * tile_size) / 2

# handles unmuting correct bus for present neighborhood
func manage_Bus_levels():
	# set each neighborhood quadrant as a variable
	var n1 = global_transform.origin.x < East_West_line and global_transform.origin.z < North_South_line
	var n2 = global_transform.origin.x < East_West_line and global_transform.origin.z > North_South_line
	var n3 = global_transform.origin.x > East_West_line and global_transform.origin.z < North_South_line
	var n4 = global_transform.origin.x > East_West_line and global_transform.origin.z > North_South_line
	# store neighborhood variables in dictionary
	var neighborhood = {3: n1, 4: n2, 5: n3, 6: n4}
	
	# set bus to mute any neighborhood that player is not occupying
	for i in range(3,7):
		AudioServer.set_bus_mute(i, !neighborhood[i])
