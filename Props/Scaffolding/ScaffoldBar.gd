extends RigidBody

var pipe_sounds = [
		preload("res://SFX/Pipes/Pipe1.ogg"), 
		preload("res://SFX/Pipes/Pipe2.ogg"),
		preload("res://SFX/Pipes/Pipe3.ogg"), 
		preload("res://SFX/Pipes/Pipe4.ogg")
		]


func pick_sound():
	$AudioStreamPlayer3D.stream = pipe_sounds[randi() % pipe_sounds.size() - 1]


func _on_ScaffoldBar_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not sleeping and not $AudioStreamPlayer3D.playing:
		pick_sound()
		$AudioStreamPlayer3D.play()
