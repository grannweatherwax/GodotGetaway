extends VehicleBody

const MAX_STEER_ANGLE = 0.35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 300
const MAX_BRAKE_FORCE = 20
const MAX_SPEED = 50


var steer_target = 0.0	# where does player want wheels to go
var steer_angle = 0.0	# where are the wheels now

sync var players = {}
var player_data = {"steer": 0, "engine": 0, "brakes": 0, "position": null, "speed": 0}

func _ready():
	join_team()
	players[name] = player_data
	players[name].position = transform
	
	if not is_local_Player():
		$Camera.queue_free()
		$GUI.queue_free()


func is_local_Player():
	return name == str(Network.local_player_id)

# handles attributing players to either the cops or robbers team
func join_team():
	# retrieve player dictionary settings and check which team
	if Network.players[int(name)]["is_cop"]:
		# add player to cops group and remove the robber mesh from player scene
		add_to_group("cops")
		$RobberMesh.queue_free()
	else: 
		# remove cop mesh from player scene
		$CopMesh.queue_free()
		

# every frame, calculate these
func _physics_process(delta):
	if is_local_Player():
		drive(delta)
		display_location()
	if not Network.local_player_id == 1:
		transform = players[name].position
	
	steering = players[name].steer
	engine_force = players[name].engine
	brake = players[name].brakes

# to drive the car, calculate these behaviors
func drive(delta):
	var speed = players[name].speed
	var steering_value = apply_steering(delta)
	var throttle = apply_throttle(speed)
	var brakes = apply_brakes()
	
	update_server(name, steering_value, throttle, brakes, speed)

# every frame, calculate and return the car's steering angle
func apply_steering(delta):
	var steer_val = 0
	var left = Input.get_action_strength("steer_left")
	var right = Input.get_action_strength("steer_right")
	
	if left: # leftward steering is a positive value, need the positive value of left's intensity
		steer_val = left
	elif right: # rightward steering is a negative value, need the negative value of right's intensity
		steer_val = -right
	steer_target = steer_val * MAX_STEER_ANGLE
	
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
	
	return steer_angle

# every frame, calculate and return the car's engine force
func apply_throttle(speed):
	var throttle_val = 0
	var forward = Input.get_action_strength("forward")
	var back = Input.get_action_strength("back")
	
	if speed < MAX_SPEED:
		if back: 
			throttle_val = -back
		elif forward:
			throttle_val = forward
	
	return throttle_val * MAX_ENGINE_FORCE

# every frame, calculate and return the car's braking force
func apply_brakes():
	var brake_val = 0
	var brake_strength = Input.get_action_strength("brake")
	
	if brake_strength:
		brake_val = brake_strength
	
	return brake_val * MAX_BRAKE_FORCE

# tell the server all of the information relating to player position based on physics controls
func update_server(id, steering_value, throttle, brakes, speed):
	if not Network.local_player_id == 1:
		rpc_unreliable_id(1, "manage_clients", id, steering_value, throttle, brakes, speed)
	else:
		manage_clients(id, steering_value, throttle, brakes, speed)
	get_tree().call_group("Interface", "update_speed", speed)

# handle keeping client players location and control status up to date
sync func manage_clients(id, steering_value, throttle, brakes, speed):
	players[id].steer = steering_value
	players[id].engine = throttle
	players[id].brakes = brakes
	players[id].position = transform
	players[id].speed = linear_velocity.length()
	rset_unreliable("players", players)

# take player's grid reference location and display to GUI
func display_location():
	# convert from float to rounded number for location
	var x = stepify(translation.x, 1)
	var z = stepify(translation.z, 1)
	
	# send location coordinates as whole numbers in string to GUI
	$GUI/ColorRect/VBoxContainer/Location.text = str(x) + ", " + str(z)
