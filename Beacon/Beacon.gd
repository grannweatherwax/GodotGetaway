extends Area

var size
var player
var wait

func _ready():
	wait = $Timer.wait_time
	# hide beacons from players who are cops
	if Network.is_cop:
		hide()

func _physics_process(delta):
	
	if not $Timer.is_stopped():
		# as long as the timer is running, the size of the beacon is decreasing proportionally
		size = $Timer.time_left / wait
		$CSGCylinder.scale.x = size
		$CSGCylinder.scale.z = size
	else:
		$CSGCylinder.scale.x = 1
		$CSGCylinder.scale.z = 1

# handles behavior when player enters beacon body
# !! unclear whether non playable physics bodies can trigger the countdown and collect payout
func _on_Beacon_body_entered(body):
	# assign player as variable value for further actions
	player = body
	# start the timer countdown
	$Timer.start()
	# show the location of the beacon to all players from now on
	show()

# handles behavior when player exits beacon body
func _on_Beacon_body_exited(body):
	# stop timer countdown
	$Timer.stop()
	# clear assignation of player from variable
	player = null

# handles behavior when timer has expired
func _on_Timer_timeout():
	# call beacon_emptied function from player to add payoff money to total holdings
	player.beacon_emptied()
	# clear this scene from the world
	queue_free()
