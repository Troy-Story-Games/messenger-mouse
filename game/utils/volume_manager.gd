extends Node

var saved_volume: Dictionary

func _ready() -> void:
	SaveAndLoad.load_game()
	var volume = SaveAndLoad.save_data.get("volume")
	if not volume:
		saved_volume = {"Master": 1.0, "SoundFX": 1.0, "Music": 1.0}
	else:
		saved_volume = volume as Dictionary

	if "Master" not in saved_volume:
		saved_volume["Master"] = 1.0
	if "SoundFX" not in saved_volume:
		saved_volume["SoundFX"] = 1.0
	if "Music" not in saved_volume:
		saved_volume["Music"] = 1.0

	print("Setting master volume: ", saved_volume["Master"])
	print("Setting music volume: ", saved_volume["Music"])
	print("Setting soundfx volume: ", saved_volume["SoundFX"])

	SaveAndLoad.add_sub_dict("volume", saved_volume)
	Utils.set_volume("Master", saved_volume["Master"])
	Utils.set_volume("SoundFX", saved_volume["SoundFX"])
	Utils.set_volume("Music", saved_volume["Music"])
	SaveAndLoad.save_game()
