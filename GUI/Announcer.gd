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
