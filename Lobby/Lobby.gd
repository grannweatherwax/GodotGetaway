extends CanvasLayer

onready var NameTextBox = $VBoxContainer/CenterContainer/GridContainer/NameTextbox
onready var port = $VBoxContainer/CenterContainer/GridContainer/PortTextbox
onready var sel_IP = $VBoxContainer/CenterContainer/GridContainer/IPTextbox

var is_cop = false

func _ready():
	NameTextBox.text = Saved.save_data["Player_name"]
	sel_IP.text = Network.DEFAULT_IP
	port.text = str(Network.DEFAULT_PORT)

# sets this player's machine as host for server
func _on_HostButton_pressed():
	# takes text entered in port textbox and sets it as the selected network port
	Network.selected_port = int(port.text)
	# stores the player's choice as cop or robber
	Network.is_cop = is_cop
	# creates the server
	Network.create_server()
	get_tree().call_group("HostOnly", "show")
	# displays waiting room where joining players can be seen
	create_waiting_room()

# sets this player as a peer who has joined network server hosted by other player
func _on_JoinButton_pressed():
	# takes text entered in port textbox and sets it as the selected network port
	Network.selected_port = int(port.text)
	# takes text entered in IP textbox and sets it as the selected network IP
	Network.selected_IP = sel_IP.text
	# stores the player's choice as cop or robber
	Network.is_cop = is_cop
	# connects to server created by host player
	Network.connect_to_server()
	# displays waiting room where joining players can be seen
	create_waiting_room()

# saves player name updates as the text is entered in the box
func _on_NameTextbox_text_changed(new_text):
	# adds entered text from the name textbox
	Saved.save_data["Player_name"] = NameTextBox.text
	# saves new name data to game's save file
	Saved.save_game()


# function creates popup of the waiting room
func create_waiting_room():
	# center popup on screen
	$WaitingRoom.popup_centered()
	# erase and redisplay player name list dynamically
	$WaitingRoom.refresh_players(Network.players)


func _on_ReadyButton_pressed():
	Network.start_game()

# what team is the player joining
func _on_TeamCheck_toggled(button_pressed):
	is_cop = button_pressed
