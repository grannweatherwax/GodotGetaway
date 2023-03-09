extends VehicleBody

# vehicular control variables
const MAX_STEER_ANGLE = 0.35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 300
const MAX_BRAKE_FORCE = 20
const MAX_SPEED = 50

var steer_target = 0.0	# where does player want wheels to go
var steer_angle = 0.0	# where are the wheels now

# money management variables
var money = 0
var money_drop = 50
var money_per_beacon = 1000

# arrest progress variables
export var max_arrest_value = 750
var arrest_value = 0
var criminal_detected = false

var siren = false

# player sync data
sync var players = {}
var player_data = {
		"steer": 0, 
		"engine": 0, 
		"brakes": 0, 
		"position": null, 
		"speed": 0, 
		"money": 0, 
		"siren": false
		}

func _ready():
	join_team()
	$PlayerBillboard/Viewport/TextureProgress.max_value = max_arrest_value
	players[name] = player_data
	players[name].position = transform
	$PlayerBillboard/Viewport/PlayerLabel.text = Network.players[int(name)]["Player_name"]
	
	if not is_local_Player():
		$Camera.queue_free()
		$GUI.queue_free()
	else:
		$PlayerBillboard/Viewport/PlayerLabel.queue_free()


func is_local_Player():
	return name == str(Network.local_player_id)

# handles attributing players to either the cops or robbers team
func join_team():
	# retrieve player dictionary settings and check which team
	if Network.players[int(name)]["is_cop"]:
		# add player to cops group and remove the robber mesh from player scene
		add_to_group("cops")
		collision_layer = 4
		$RobberMesh.queue_free()
	else: 
		# remove cop mesh from player scene
		$CopMesh.queue_free()
		# remove the crime in progress indication arrow from the robber's player scene
		$Arrow.queue_free()
		$Siren.queue_free()
		

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
	
	if is_in_group("cops"):
		check_siren()
	
	if criminal_detected:
		increment_arrest_value()

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
	# unreliable remote call to update with ongoing changes to player values
	rset_unreliable("players", players)

# take player's grid reference location and display to GUI
func display_location():
	# convert from float to rounded number for location
	var x = stepify(translation.x, 1)
	var z = stepify(translation.z, 1)
	
	# send location coordinates as whole numbers in string to GUI
	$GUI/ColorRect/VBoxContainer/Location.text = str(x) + ", " + str(z)

# handles triggering money management as beacon is emptied
func beacon_emptied():
	# updates player's money holdings with beacon's amount
	money += money_per_beacon
	# triggers updating player dictionary and GUI updating for host and clients
	manage_money()

# handles host vs client updating player dictionary with money holdings
func manage_money():
	if Network.local_player_id == 1:
		update_money(name, money)
	else:
		rpc_id(1, "update_money", name, money)

# handles host vs client updates to money holdings for display
remote func update_money(id, cash):
	# get reference to player's currently held money
	players[id].money = cash
	# if player is host, run display money locally
	if name == "1":
		display_money(cash)
	# if player is client, rpc display money on host machine
	else: rpc_id(int(id), "display_money", cash)

# handles updating the display of money amounts held by players in the GUI
remote func display_money(cash):
	# get reference to player's currently held mondy
	money = players[name].money
	# runs animation in money display
	$GUI/ColorRect/VBoxContainer/MoneyLabel/AnimationPlayer.play("MoneyPulse")
	# updates displayed money amount in player GUI
	$GUI/ColorRect/VBoxContainer/MoneyLabel.text = "$" + str(cash)

func money_delivered():
	# within the group Announcements, run money_stashed function and pass in player name and money parameters
	get_tree().call_group("Announcements", "money_stashed", Saved.save_data["Player_name"], money)
	# reset player's money to zero
	money = 0
	# run manage money now that everything is updated
	manage_money()

# handles collision results between player body and money items
func _on_Player_body_entered(body):
	if body.has_node("Money"):
		body.queue_free()
		money += money_drop
	elif money > 0 and not is_in_group("cops"):
		spawn_money()
		money -= money_drop
	manage_money()

# handles spawning money drops in the world during gameplay
func spawn_money():
	# preload the moneybag scene instance
	var moneybag = preload("res://Props/MoneyBag/MoneyBag.tscn").instance()
	# spawn the moneybag at the player's position 4m above their y
	moneybag.translation = Vector3(translation.x, 4, translation.z)
	# move up the scene hierarchy into the the main node of world and add moneybag instance as child
	# moneydrops are not going to be visible to other players, but can be picked up
	# so added functionality could be to allow the moneybag rigidbody to sleep and on sleep add it to networked scene?
	get_parent().get_parent().add_child(moneybag)

func _input(event):
	if event.is_action_pressed("car_sound") and is_local_Player() and is_in_group("cops"):
		# change current value of siren to its opposite
		siren = !siren
		# if you're not the host then run the function
		if not Network.local_player_id == 1:
			# send the rpc to host machine along with siren-using player's name and siren status
			rpc_id(1, "toggle_siren", name, siren)
		else:
			# if you're the the host run the function
			toggle_siren(name, siren)

# handle remotely toggling siren status for each player's dictionary entry
remote func toggle_siren(id, siren_state):
	players[id]["siren"] = siren_state
	

func check_siren():
	if players[name]["siren"]:
		# siren is on, so monitor whether cop is in arresting range
		$Siren/ArrestArea.monitoring = true
		# if the siren stream isn't already playing, play it now
		if not $Siren/AudioStreamPlayer3D.playing:
			$Siren/AudioStreamPlayer3D.play()
		# show the police car roof lights
		$Siren/SirenMesh/SpotLight.show()
		$Siren/SirenMesh/SpotLight2.show()
	else:
		# siren is off, so don't monitor whether cop is in arresting range
		$Siren/ArrestArea.monitoring = false
		# turn off the siren audio
		$Siren/AudioStreamPlayer3D.stop()
		# show the police car roof lights
		$Siren/SirenMesh/SpotLight.hide()
		$Siren/SirenMesh/SpotLight2.hide()

# handles detecting when robber car is in arresting distance
func _on_ArrestArea_body_entered(body):
	body.criminal_detected = true

# handles detecting when robber car is no longer in arresting distance
func _on_ArrestArea_body_exited(body):
	body.criminal_detected = false

# handles progress toward completed arrest
func increment_arrest_value():
	# increment
	arrest_value += 1
	# update player billboard to show new value
	$PlayerBillboard/Viewport/TextureProgress.value = arrest_value
