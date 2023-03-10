extends Node

var save_data = {}
const SAVEGAME = "user://Savegame.json"

func _ready():
	save_data = get_data()

# handle reading of previously saved data
func get_data():
	# First create a file variable and make it a new File class
	var file = File.new()
	if not file.file_exists(SAVEGAME):
		# add player name and local paint color to json save data
		save_data = {"Player_name": "Unnamed", 
				"local_paint_color": "FF6E2626"}
		save_game()
	# Assign the data from SAVEGAME to the new file and read it
	file.open(SAVEGAME, File.READ)
	# transform the file into text and assign it to the new variable called content
	var content = file.get_as_text()
	# parse the content as a json and assign it to a new variable called data
	var data = parse_json(content)
	# overwrite the variable save_data with value of variable data
	save_data = data
	# close the file opened
	file.close()
	# return the value of the variable data: json values of the file called SAVEGAME
	return(data)

# handle writing of new save data
func save_game():
	var save_game = File.new()
	save_game.open(SAVEGAME, File.WRITE)
	save_game.store_line(to_json(save_data))
