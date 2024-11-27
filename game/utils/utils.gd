extends Node

const levels_path = "res://game/level/levels/"

var levels: Array[PackedScene] = []

func _ready() -> void:
	var level_dict: Dictionary = Utils.load_dict_from_path(levels_path)
	for key in level_dict:
		levels.append(level_dict[key])

func get_level(idx: int) -> PackedScene:
	return levels[idx]

func set_volume(bus_name: String, value: float) -> void:
	var idx: = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, linear_to_db(value))

func menu_beep(_unused: int = 0) -> void:
	if not SoundFx.is_playing("menu_beep"):
		SoundFx.play("menu_beep", 1, -15, 0)

func instantiate_scene_on_level(scene: PackedScene, position: Vector2) -> Node:
	var node: = scene.instantiate()
	node.position = position
	var main = get_tree().current_scene as World
	if main is World:
		var level: = main.current_level as Level
		if level is Level:
			level.add_child(node)
		else:
			# NOTE: fallback to make it work if no level
			main.add_child(node)

	return node

func load_dict_from_path(dir_path: String, file_exts: Array[String] = [".tscn"]):
	var look_for_exts = []
	var ret := {}
	var dir := DirAccess.open(dir_path)
	if not dir:
		push_error("Could not find dirctory ", dir_path)
		return ret

	for ext in file_exts:
		look_for_exts.append(ext)
		look_for_exts.append(ext + ".import")
		look_for_exts.append(ext + ".remap")

	print_verbose("Loading files from ", dir_path, " with extensions ", file_exts)

	dir.list_dir_begin()
	var check := dir.get_next()
	while check != "":
		print_verbose("Checking ", check)
		for ext in look_for_exts:
			if not check.ends_with(ext):
				continue
			var split := check.split(".", false)
			var fname: String = split[0]
			var fext: String = split[1]
			var full_path := dir_path + fname + "." + fext
			if fname not in ret:
				print_verbose("Adding " + fname + " = " + full_path)
				ret[fname] = load(full_path)
			break
		check = dir.get_next()
	return ret

func ms_to_string(time_ms: float) -> String:
	var rem_ms: = time_ms
	var rem_m: = int(floor((rem_ms / 1000.0) / 60.0))
	rem_ms -= rem_m * 60 * 1000
	var rem_s: = int(floor(rem_ms / 1000.0))
	rem_ms -= rem_s * 1000
	return "%02d:%02d:%02d" % [rem_m, rem_s, int(floor(rem_ms / 10.0))]
