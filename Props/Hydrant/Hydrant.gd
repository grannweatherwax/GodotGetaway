extends Spatial

# allows hydrant to spawn without that collision triggering game behavior
var has_finished_spawning = false

# when timer expires, hydrant disappears
func _on_Timer_timeout():
	queue_free()

# handles behavior when hydrant area collision is triggered
func _on_Area_body_entered(body):
	$CarPusher/AnimationPlayer.play("CarPUsh")

# handles behavior when hydrant sleeping state has been flipped
func _on_FireHydrant_sleeping_state_changed():
	# behavior when hydrant is not sleeping and it's done spawning (gameplay active + collision detected)
	if not $FireHydrant.sleeping and has_finished_spawning:
		# start emitting particles
		$Particles.emitting = true
		# start the expiration timer
		$Timer.start()
	else: # behavior when gameplay isn't yet active (the hydrant is spawning)
		# change bool for has_finished_spawning to prep for gameplay collision behaviors
		has_finished_spawning = true
