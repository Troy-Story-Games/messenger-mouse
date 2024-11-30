extends Node

var saved_audio: Dictionary

func _ready() -> void:
	SaveAndLoad.load_game()
	var audio = SaveAndLoad.save_data.settings.audio
	if not audio:
		saved_audio = {"Master": 1.0, "SoundFX": 1.0, "Music": 1.0}
	else:
		saved_audio = audio as Dictionary

	if "Master" not in saved_audio:
		saved_audio["Master"] = 1.0
	if "SoundFX" not in saved_audio:
		saved_audio["SoundFX"] = 1.0
	if "Music" not in saved_audio:
		saved_audio["Music"] = 1.0

	print("Setting master volume: ", saved_audio["Master"])
	print("Setting music volume: ", saved_audio["Music"])
	print("Setting soundfx volume: ", saved_audio["SoundFX"])

	SaveAndLoad.save_data.settings.audio = saved_audio
	Utils.set_volume("Master", saved_audio["Master"])
	Utils.set_volume("SoundFX", saved_audio["SoundFX"])
	Utils.set_volume("Music", saved_audio["Music"])
	SaveAndLoad.save_game()
