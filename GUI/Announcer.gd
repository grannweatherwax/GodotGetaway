extends CenterContainer

# handles the rpc about stashing money
func money_stashed(player, money):
	rpc("announce_money", player, money)

# handles populating and playing animation for money stashing announcement
sync func announce_money(player, money):
	# set the label text for the announcement with amount and player name
	$Label.text = "$" + str(money) + " has been stashed by " + player
	# plays animation
	$AnimationPlayer.play("Announcement")

# handles showing where the money drop crime is taking place on the map
sync func announce_crime(location):
	# return the whole number values for x and z and set as variables
	var x = stepify(location.x, 1)
	var z = stepify(location.z, 1)
	# set the announcement label text using location values
	$Label.text = "Crime in progress at " + str(x) + " , " + str(z)
	# play the announcement animation
	$AnimationPlayer.play("Announcement")
	# call the new_destination function from the Arrow group
	get_tree().call_group("Arrow", "new_destination", location)
