extends Spatial

var paint
var default_color

func _ready():
	make_material()
	# set the default color to the last color saved within the user's json data file
	default_color = Color(Saved.save_data["local_paint_color"])
	apply_defaults()

func pivot():
	$AudioStreamPlayer.play()
	var rot = $Pivot.rotation_degrees.y
	$Tween.interpolate_property($Pivot, "rotation_degrees",
			Vector3(0, rot, 0), Vector3(0, rot + 180, 0),
			1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	$Tween.start()

func make_material():
	var new_paint = load("res://Lobby/DefaultCarPaint.tres")
	$Pivot/Criminal1.set_surface_material(0, new_paint)
	$Pivot/Criminal2.set_surface_material(0, new_paint)
	$Pivot/Cop1.set_surface_material(0, new_paint)
	$Pivot/Cop2.set_surface_material(0, new_paint)
	paint = $Pivot/Criminal1.get_surface_material(0)

func apply_defaults():
	paint.metallic = 0.75
	paint.metallic_specular = 0.25
	paint.roughness = 0.25
	paint.albedo_color = default_color

func new_color(color):
	paint.albedo_color = color
