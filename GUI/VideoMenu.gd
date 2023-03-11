extends Popup

func _ready():
	var dof = $VBoxContainer/CenterContainer/GridContainer/DOFCheck
	var reflections = $VBoxContainer/CenterContainer/GridContainer/ReflectionCheck
	var fog = $VBoxContainer/CenterContainer/GridContainer/FogCheck
	var particles = $VBoxContainer/CenterContainer/GridContainer/ParticlesCheck
	var far_cam = $VBoxContainer/CenterContainer/GridContainer/FarCheck
	
	# set displayed toggles to match saved user settings
	dof.pressed = Saved.save_data["dof"]
	reflections.pressed = Saved.save_data["reflections"]
	fog.pressed = Saved.save_data["fog"]
	particles.pressed = Saved.save_data["particles"]
	far_cam.pressed = Saved.save_data["far_cam"]

# send DOF changes to Camera
func _on_DOFCheck_toggled(button_pressed):
	get_tree().call_group("Cameras", "dof", button_pressed)

# send Reflections changes to Camera
func _on_ReflectionCheck_toggled(button_pressed):
	get_tree().call_group("Cameras", "reflections", button_pressed)

# send Fog changes to Camera
func _on_FogCheck_toggled(button_pressed):
	get_tree().call_group("Cameras", "fog", button_pressed)

# send Particles changes to Exhaust
func _on_ParticlesCheck_toggled(button_pressed):
	get_tree().call_group("Particles", "manage_particles", button_pressed)

# send Far Camera changes to Camera
func _on_FarCheck_toggled(button_pressed):
	get_tree().call_group("Cameras", "far_cam", button_pressed)

func _on_DoneButton_pressed():
	hide()
