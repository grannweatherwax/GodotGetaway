extends Camera

# get reference to the player node
onready var car = get_node("../../../../../..")

var minimum_height = 50
var speed = 0

func _physics_process(delta):
	var height = speed * 2 + minimum_height
	# handle tracking the player position within the world and following with the camera
	# the faster the player moves, the higher above the level the camera is positioned
	translation = Vector3(car.translation.x, height, car.translation.z)

func update_speed(new_speed):
	speed = new_speed
