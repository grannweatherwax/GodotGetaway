extends Spatial

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

# spawn the instance of yourself on the networked machines
remote func spawn_remote_player(id):
	var new_player = preload("res://Player/Player.tscn").instance()
	# spawn player at the center of the placed gridmap, rather than at 0,0
	new_player.translation = Vector3(12, 3, 12)
	new_player.name = str(id)
	$Players.add_child(new_player)

func unpause():
	get_tree().paused = false
	# spawn myself on my machine
	spawn_local_player()
	# tell every other machine on the network to spawn me as well
	rpc("spawn_remote_player", Network.local_player_id)
