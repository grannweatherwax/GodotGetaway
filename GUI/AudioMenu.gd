extends Popup

func _ready():
	# set values displayed on sliders to the current values from the save data
	$ColorRect/VBoxContainer/MasterVolumeSlider.value = Saved.save_data["master_volume"]
	$ColorRect/VBoxContainer/SFXVolumeSlider.value = Saved.save_data["sfx_volume"]
	$ColorRect/VBoxContainer/MusicVolumeSlider.value = Saved.save_data["music_volume"]

func _on_DoneButton_pressed():
	# hide the audio menu on press
	hide()

# handle changes to master volume slider
func _on_MasterVolumeSlider_value_changed(value):
	VolumeControl.update_master_volume(value)

# handle changes to sfx volume slider
func _on_SFXVolumeSlider_value_changed(value):
	VolumeControl.update_sfx_volume(value)

# handle changes to music volume slider
func _on_MusicVolumeSlider_value_changed(value):
	VolumeControl.update_music_volume(value)
