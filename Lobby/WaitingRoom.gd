extends Popup

onready var Playerlist = $VBoxContainer/CenterContainer/ItemList

func _ready():
	Playerlist.clear()

# handle refreshing player list within waiting room
func refresh_players(players):
	# start by clearing away any predefined values from the item list
	Playerlist.clear()
	# grab all data from the player dictionary
	# use the id from before to find player name
	for player_id in players:
		var player = players[player_id]["Player_name"]
		# add player name based on their id to the list
		Playerlist.add_item(player, null, false)
