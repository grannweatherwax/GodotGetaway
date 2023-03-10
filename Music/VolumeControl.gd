extends Node

# singleton to control volume levels from any scene and consistent from one play
# session to the next

# variables for audio buses
const MASTER_BUS = 0
const SFX_BUS = 1
const MUSIC_BUS = 2

func _ready():
	# set variables to values from saved data file
	var master_volume = Saved.save_data["master_volume"]
	var sfx_volume = Saved.save_data["sfx_volume"]
	var music_volume = Saved.save_data["music_volume"]
	
	# set volume levels in db, applying the values from save data to the audio buses themselves
	AudioServer.set_bus_volume_db(MASTER_BUS, master_volume)
	AudioServer.set_bus_volume_db(SFX_BUS, sfx_volume)
	AudioServer.set_bus_volume_db(MUSIC_BUS, music_volume)

# handles updates to master volume
func update_master_volume(master_volume):
	# set volume levels in db, applying the values from save data to the audio buses themselves
	AudioServer.set_bus_volume_db(MASTER_BUS, master_volume)
	# set value of volume parameter to the saved data file
	Saved.save_data["master_volume"] = master_volume
	# save the changed data file
	Saved.save_game()

# handles updates to sfx
func update_sfx_volume(sfx_volume):
	# set volume levels in db, applying the values from save data to the audio buses themselves
	AudioServer.set_bus_volume_db(SFX_BUS, sfx_volume)
	# set value of volume parameter to the saved data file
	Saved.save_data["sfx_volume"] = sfx_volume
	# save the changed data file
	Saved.save_game()

# handles updates to music
func update_music_volume(music_volume):
	# set volume levels in db, applying the values from save data to the audio buses themselves
	AudioServer.set_bus_volume_db(MUSIC_BUS, music_volume)
	# set value of volume parameter to the saved data file
	Saved.save_data["music_volume"] = music_volume
	# save the changed data file
	Saved.save_game()
