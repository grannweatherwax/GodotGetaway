extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 32023
const MAX_PLAYERS = 4


var selected_port
var selected_IP

var local_player_id = 0
sync var players = {}
sync var player_data = {}
var ready_players = 0

signal player_disconnected
signal server_disconnected

var is_cop = false
var city_size = Vector2()
var prop_multiplier

var world_seed

func _ready():
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnect")
	get_tree().connect("network_peer_connected", self, "_on_player_connected")

# When I press host server, prepare my machine to act as host
func create_server():
	# set a new instance of a peer to peer network using the variable peer
	var peer = NetworkedMultiplayerENet.new()
	# create the server for peer using the IP I entered and the maximum number of players allowed
	peer.create_server(selected_port, MAX_PLAYERS)
	# Set this machine as the server master for the peer variable
	get_tree().set_network_peer(peer)
	# add the player to the list of players in the waiting room
	add_to_player_list()

# Connect to a server set up by someone else
func connect_to_server():
	# set a new instance of a peer to peer network using the variable peer
	var peer = NetworkedMultiplayerENet.new()
	# connect to an existing server, sending the signal saying puppet is connected and running function connected to server
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	# set current machine as a client of the host server at IP and port entered in the lobby
	peer.create_client(selected_IP, selected_port)
	# set the puppet as a network peer to the server
	get_tree().set_network_peer(peer)

# add player to list of game players
func add_to_player_list():
	# set the unique network id of the player as their local id
	local_player_id = get_tree().get_network_unique_id()
	# set the locally saved data as the player's player data
	player_data = Saved.save_data
	# add the player's player_data to the dictionary of players
	players[local_player_id] = player_data
	# add the key and value of "is_cop" to the player dictionary
	players[local_player_id]["is_cop"] = is_cop
	# add paint_color to user data json
	players[local_player_id]["paint_color"] = Saved.save_data["local_paint_color"]

# handle actions when player has connected to the server
func _connected_to_server():
	# add connected player to player list
	add_to_player_list()
	# remote procedure call, safe method, sends player info from the dictionary entry of local player id and the player's data
	rpc("_send_player_info", local_player_id, player_data, is_cop)

# handle sending the player's data
remote func _send_player_info(id, player_info, cop_mode):
	# set the player's dictionary entry according to their local player id and the player info passed in
	players[id] = player_info
	# set the player's status as cop or robber within the player dictionary
	players[id]["is_cop"] = cop_mode
	# run this if the player is the host
	if get_tree().is_network_server():
		# send the dictionary of players
		rset("players", players)
		# remote procedure call, safe method, update the data displayed in the waiting room
		rpc("update_waiting_room")

# handle what happens when a player has connected to the server
func _on_player_connected(id):
	if not get_tree().is_network_server():
		print(str(id) + " has connected.")

# handle how to update the waiting room
sync func update_waiting_room():
	# within the waiting room group, refresh the players listed with the data drawn from var players
	get_tree().call_group("WaitingRoom", "refresh_players", players)

func start_game():
	rpc("load_world")

sync func load_world():
	get_tree().change_scene("res://World/World.tscn")
