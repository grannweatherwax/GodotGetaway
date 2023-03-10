extends Spatial

func pivot():
	$AudioStreamPlayer.play()
	var rot = $Pivot.rotation_degrees.y
	$Tween.interpolate_property($Pivot, "rotation_degrees",
			Vector3(0, rot, 0), Vector3(0, rot + 180, 0),
			1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	$Tween.start()
