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

func _on_Beacon_body_entered(body):
	player = body
	$Timer.start()
	show()


func _on_Beacon_body_exited(body):
	$Timer.stop()
	player = null


func _on_Timer_timeout():
	queue_free()
