extends Node

var sounds_path: = "res://game/audio/soundfx/sounds/"
var sounds: = {}

@onready var sound_players: = $StreamPlayers.get_children()
@onready var sound_players_2d: = $StreamPlayers2D.get_children()


func _ready() -> void:
    sounds = Utils.load_dict_from_path(sounds_path, [".ogg", ".wav", ".mp3"])


func play(sound_string: String, pitch_scale: float = 1, volume_db: float = -15.0) -> AudioStreamPlayer:
    for player in sound_players:
        if not player.playing:
            player.pitch_scale = pitch_scale
            player.volume_db = volume_db
            player.stream = sounds[sound_string]
            player.bus = "SoundFX"
            player.process_mode = Node.PROCESS_MODE_ALWAYS
            player.play()
            return player
    push_error("[UNBOXING] WARNING: Too many sounds playing at once!")
    return null


func play_2d(sound_string: String, global_position: Vector2, pitch_scale: float = 1.0, volume_db: float = -15.0, max_distance: float = 0.0) -> AudioStreamPlayer2D:
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
    push_error("[UNBOXING] WARNING: Too many sounds playing at once!")
    return null
