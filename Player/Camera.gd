extends Camera

const MAX_CAMERA_ANGLE = 90

var East_West_line
var North_South_line

# allows camera to be told "find this object and set it as your target" 
export (NodePath) var follow_this_path = null

export var target_distance = 15.0
export var target_height = 1.0

var follow_this = null
var last_lookat

var tile_size = 20
var tile_offset = 10

func _ready():
	make_neighborhoods()
	# allows camera to move independently from its parent node
	set_as_toplevel(true)
	environment = load(Network.environment)
	# sets the local variable to the node it needs to follow
	follow_this = get_node(follow_this_path)
	# the last thing you looked at is the global position of the camera target
	# this helps the camera movement to move more smoothly
	last_lookat = follow_this.global_transform.origin

func _physics_process(delta):
	# if East_West_line has been defined, manage the audiobus levels
	if East_West_line != null:
		manage_Bus_levels()
	
	# set as variable the difference between where camera currently is and where it needs to go
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	# set as variable the Vector3 of the distance from origin
	var target_pos = global_transform.origin
	
	# clear delta_v's y value 
	delta_v.y = 0
	
	# allows for camera to lag behind slightly, catch up, and stop in position in response to car behavior
	# if the difference between camera position (x,z) and camera target (x,z) is greater than the target_distance (x,z) allowed
	if delta_v.length() > target_distance:
		# reset delta_v value to its normalized value * target allowed distance
		delta_v = delta_v.normalized() * target_distance
		# force update the y value to the allowed target height
		delta_v.y = target_height
		# reset the target position to the new delta_v + the follow_this values (both are Vector3)
		# set where we want to be as the target plus how far we can move
		target_pos = follow_this.global_transform.origin + delta_v
	# if the difference between camera position and camera target is not greater than the target_distance allowed
	else: 
		# update y value for target_pos to the target height and the follow_this y value
		# aka only worry about the possible changes in height
		target_pos.y = follow_this.global_transform.origin.y + target_height
	
	# move the camera with linear interpolatation
	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, 1) # go to target_pos, it should take 1 second
	
	# update last_lookat toward the follow_this value over 1 second with linear interpolation
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, 1)
	
	# rotate the view toward last_lookat Vector3 value, keeping the camera upright (second parameter)
	look_at(last_lookat, Vector3(0, 1, 0))

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

func update_speed(speed):
	fov = 70 + speed
	fov = min(fov, MAX_CAMERA_ANGLE)
