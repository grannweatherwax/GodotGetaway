extends CenterContainer

# handle removal of announcement conflicts to play most currently called announcement
func announce():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Announcement")

# handles the rpc about stashing money
func money_stashed(player, money):
	rpc("announce_money", player, money)

# handles populating and playing animation for money stashing announcement
sync func announce_money(player, money):
	# set the label text for the announcement with amount and player name
	$Label.text = "$" + str(money) + " has been stashed by " + player
	# plays animation
	announce()

# handles showing where the money drop crime is taking place on the map
sync func announce_crime(location):
	# return the whole number values for x and z and set as variables
	var x = stepify(location.x, 1)
	var z = stepify(location.z, 1)
	# set the announcement label text using location values
	$Label.text = "Crime in progress at " + str(x) + " , " + str(z)
	# play the announcement animation
	announce()
	# call the new_destination function from the Arrow group
	get_tree().call_group("Arrow", "new_destination", location)

func victory(robbers_win):
	rpc("announce_victory", robbers_win)

# handles setting correct victory announcement based on winner
sync func announce_victory(robbers_win):
	if robbers_win:
		$Label.text = "Robbers win! Crime pays!"
	else: 
		$Label.text = "Cops win! Time to get these criminals on cleanup duty!"
	announce()
