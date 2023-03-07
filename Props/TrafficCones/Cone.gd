extends RigidBody

# set bool so that spawning action doesn't activate the post-collision timer
var has_finished_spawning = false

# when the timer after collision expires, despawn the cone
func _on_Timer_timeout():
	queue_free()

# handles collision behavior for the cone
func _on_Cone__body_entered(body):
	# if the sfx isn't already playing, play it
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play()

# handles cone's sleeping state changes
func _on_Cone__sleeping_state_changed():
	# timer is allowed to start if the cone isn't sleeping and it's not the spawn collision
	if not sleeping and has_finished_spawning:
		$Timer.start()
	# if it's the collision for spawning, then set the has_finished_spawning to true 
	# to prep for further gameplay collisions
	else:
		has_finished_spawning = true
