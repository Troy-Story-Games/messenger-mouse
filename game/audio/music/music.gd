extends Node

var songs_path := "res://game/audio/music/songs/"
var songs := {}
var song_playing: String = ""

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	songs = Utils.load_dict_from_path(songs_path, [".ogg", ".wav", ".mp3"])

func play(song_string: String, pitch_scale: float = 1, volume_db: float = -25.0, crossfade: float = 0.0) -> void:
	if audio_stream_player.playing and crossfade > 0.0:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -80, crossfade / 2.0)
		await tween.finished

	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.volume_db = volume_db
	audio_stream_player.stream = songs[song_string]
	audio_stream_player.play()
	song_playing = song_string

	if crossfade:
		audio_stream_player.volume_db = -80
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", volume_db, crossfade / 2.0)

func is_playing(song_name: String) -> bool:
	if audio_stream_player.playing and song_playing == song_name:
		return true
	return false

func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()
