extends CSGBox

func _ready():
	# assign a random material via the pick_random_material function
	var selected_material = pick_random_material()
	# load that material and set it as variable material
	material = load(selected_material)

# handles returning a random billboard material from its folder for use in scene
func pick_random_material():
	# create list of materials stored in the billboard materials folder
	var materials_list = get_files("res://Props/Billboards/BillboardMaterials/")
	# select one material from the list randomly and assign it as selected_material
	var selected_material = materials_list[randi() % materials_list.size()]
	# return that material
	return selected_material

# handles returning all material files from the folder passed in
func get_files(folder):
	# create new dictionary for gathered files to go into
	var gathered_files = {}
	# file counter variable will be used as the dictionary key
	var file_count = 0
	# create a new Directory called dir
	var dir = Directory.new()
	
	# open the folder which needs to be streamed into the dir variable
	dir.open(folder)
	# start streaming through all the files within this directory
	dir.list_dir_begin()
	
	while true:
		# set the next entry of the dir as variable file
		var file = dir.get_next()
		# if we've reached the end of the directory, stop
		if file == "":
			break
		# otherwise, don't process any .import files, exclude by excluding prefix "." and instead do this:
		elif not file.begins_with("."):
			# at the position of the file_count iterator, place the file address as folder + file strings
			gathered_files[file_count] = folder + file
			# iterate the file_count variable
			file_count += 1
	
	return gathered_files
