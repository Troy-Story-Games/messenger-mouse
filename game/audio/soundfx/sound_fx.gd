extends Node

var sounds_path: = "res://game/audio/soundfx/sounds/"
var sounds: = {}

@onready var sound_players: Array[Node] = $StreamPlayers.get_children() as Array[Node]
@onready var sound_players_2d: Array[Node] = $StreamPlayers2D.get_children() as Array[Node]

func _ready() -> void:
	sounds = Utils.load_dict_from_path(sounds_path, [".ogg", ".wav", ".mp3"])

func random_pitch_scale(pitch_scale: float, pitch_scale_random: float) -> float:
	var lowest: = pitch_scale - pitch_scale_random
	var highest: = pitch_scale + pitch_scale_random
	return randf_range(lowest, highest)

func is_playing(song_name: String) -> bool:
	for player in sound_players:
		if player.playing and song_name in player.stream.resource_path:
			return true
	return false

func play(sound_string: String, pitch_scale: float = 1, volume_db: float = -15.0, pitch_scale_random: float = 0.3) -> AudioStreamPlayer:
	if pitch_scale_random != 0.0:
		pitch_scale = random_pitch_scale(pitch_scale, pitch_scale_random)

	for player in sound_players:
		if not player.playing:
			player.pitch_scale = pitch_scale
			player.volume_db = volume_db
			player.stream = sounds[sound_string]
			player.bus = "SoundFX"
			player.process_mode = Node.PROCESS_MODE_ALWAYS
			player.play()
			return player
	print_debug("WARNING: Too many sounds playing at once!")
	return null

func play_2d(sound_string: String, global_position: Vector2, pitch_scale: float = 1.0, volume_db: float = -15.0, max_distance: float = 450, pitch_scale_random: float = 0.1) -> AudioStreamPlayer2D:
	if pitch_scale_random != 0.0:
		pitch_scale = random_pitch_scale(pitch_scale, pitch_scale_random)

	for player in sound_players_2d:
		if not player.playing:
			player.pitch_scale = pitch_scale
			player.volume_db = volume_db
			player.bus = "SoundFX"
			player.stream = sounds[sound_string]
			player.global_position = global_position
			player.max_distance = max_distance
			player.play()
			return player
	print_debug("WARNING: Too many sounds playing at once!")
	return null
