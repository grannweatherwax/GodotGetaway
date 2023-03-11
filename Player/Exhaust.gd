extends Particles

const MAX_LIFETIME = 2

func _ready():
	emitting = Saved.save_data["particles"]

# let speed influence the rate of particle lifetime
func update_particles(speed):
	if speed > 0: 
		lifetime = MAX_LIFETIME / speed
	else:
		lifetime = MAX_LIFETIME / .01

# handle updating particles value in save data
func manage_particles(value):
	# set particle emission to passed in bool value 
	emitting = value
	# set save data to passed in bool value
	Saved.save_data["particles"] = value
	# write new save data
	Saved.save_game()



