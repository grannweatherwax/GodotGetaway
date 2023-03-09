extends Spatial

var money_stashed = 0
var money_recovered = 0
export var criminal_victory_score = 3000
export var cop_victory_score = 3000

var cop_spawn

func _enter_tree():
	get_tree().paused = true

func _ready():
	pass

# spawn an instance of yourself on your own maching
func spawn_local_player():
	# create a new instance of the player scene (your car)
	var new_player = preload("res://Player/Player.tscn").instance()
	# assign the local player id as your car's instance name
	new_player.name = str(Network.local_player_id)
	# spawn player at the center of the placed gridmap, rather than at 0,0
	new_player.translation = Vector3(12, 3, 12)
	# add this to the scene
	$Players.add_child(new_player)
	if Network.is_cop:
		yield(get_tree(), "idle_frame")
		new_player.translation = cop_spawn

# spawn the instance of yourself on the networked machines
remote func spawn_remote_player(id):
	var new_player = preload("res://Player/Player.tscn").instance()
	# spawn player at the center of the placed gridmap, rather than at 0,0
	new_player.translation = Vector3(12, 3, 12)
	new_player.name = str(id)
	$Players.add_child(new_player)
	if new_player.is_in_group("cops"):
		yield(get_tree(), "idle_frame")
		new_player.translation = cop_spawn

func unpause():
	get_tree().paused = false
	# spawn myself on my machine
	spawn_local_player()
	# tell every other machine on the network to spawn me as well
	rpc("spawn_remote_player", Network.local_player_id)

# handles updating money stashed and updating money recovered
remote func update_gamestate(stashed, recovered):
	# if player is the host, run this locally
	if Network.local_player_id == 1:
		money_stashed += stashed
		money_recovered += recovered
		check_win_conditions()
	# if player is a client, run this remotely on the host
	else: 
		rpc_id(1, "update_gamestate", stashed, recovered)

# handles testing whether cops or robbers have reached a win state
func check_win_conditions():
	if money_stashed >= criminal_victory_score:
		get_tree().call_group("Announcements", "victory", true)
	elif money_recovered >= cop_victory_score:
		get_tree().call_group("Announcements", "victory", false)

# handles spawning the cop into the world
func _on_ObjectSpawner_cop_spawn(location):
	cop_spawn = location
