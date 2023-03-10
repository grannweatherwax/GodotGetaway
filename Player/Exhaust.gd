extends Particles

const MAX_LIFETIME = 2

# let speed influence the rate of particle lifetime
func update_particles(speed):
	if speed > 0: 
		lifetime = MAX_LIFETIME / speed
	else:
		lifetime = MAX_LIFETIME / .01
