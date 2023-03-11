extends CanvasLayer

onready var NameTextBox = $VBoxContainer/CenterContainer/GridContainer/NameTextbox
onready var port = $VBoxContainer/CenterContainer/GridContainer/PortTextbox
onready var sel_IP = $VBoxContainer/CenterContainer/GridContainer/IPTextbox

var is_cop = false
var city_size
var environment = "res://Environments/night.tres"

func _ready():
	NameTextBox.text = Saved.save_data["Player_name"]
	sel_IP.text = Network.DEFAULT_IP
	port.text = str(Network.DEFAULT_PORT)
	_on_CitySizePicker_item_selected(1)
	# sets previously selected/default from json as pre-selected color
	$VBoxContainer/CenterContainer/GridContainer/ColorPickerButton.color = Saved.save_data["local_paint_color"]

# sets this player's machine as host for server
func _on_HostButton_pressed():
	# takes text entered in port textbox and sets it as the selected network port
	Network.selected_port = int(port.text)
	# stores the player's choice as cop or robber
	Network.is_cop = is_cop
	# creates the server
	Network.create_server()
	# set variable city_size in Network class to local value of city_size
	Network.city_size = city_size
	Network.environment = environment
	generate_city_seed()
	# call the show() method for nodes in the HostOnly group
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

func generate_city_seed():
	var world_seed = $VBoxContainer/CenterContainer/GridContainer/CitySeed.text
	# convert city name text to hash value and set as world seed
	if world_seed == "":
		randomize()
		Network.world_seed = randi()
	else:
		Network.world_seed = hash(world_seed)

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

# handles rotating cop/robber cars as team selection is toggled
func _on_TeamCheck_item_selected(index):
	# if the is_cop variable is the same as the index boolean, do this
	if not int(is_cop) == index:
		var button = $VBoxContainer/CenterContainer/GridContainer/TeamCheck
		button.set_item_disabled(0, true)
		button.set_item_disabled(1, true)
		is_cop = index
		$LobbyBackground.pivot()

func _on_Tween_tween_completed(object, key):
	var button = $VBoxContainer/CenterContainer/GridContainer/TeamCheck
	button.set_item_disabled(0, false)
	button.set_item_disabled(1, false)

# handles behavior when color is changed in ColorPickerButton
func _on_ColorPickerButton_color_changed(color):
	# run new_color function from LobbyBackground class, pass in color
	$LobbyBackground.new_color(color)
	# set color as html and assign to local_paint_color key in save_data
	Saved.save_data["local_paint_color"] = color.to_html()
	# run save_game method of Saved class
	Saved.save_game()

# handle city size selection from lobby
func _on_CitySizePicker_item_selected(index):
	# for each id, update values for city_size and prop_multiplier
	match index:
		0:
			city_size = Vector2(15, 15)
			Network.prop_multiplier = 0.5
		1: 
			city_size = Vector2(20, 20)
			Network.prop_multiplier = 1
		2: 
			city_size = Vector2(40, 40)
			Network.prop_multiplier = 2
		3:
			city_size = Vector2(100, 100)
			Network.prop_multiplier = 5

func _on_TimeCheck_item_selected(index):
	match index:
		0:
			environment = "res://Environments/night.tres"
		1:
			environment = "res://Environments/day.tres"













func _on_OptionsButton_pressed():
	$InGameMenu.popup_centered()
