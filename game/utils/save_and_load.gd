extends Node

const SAVE_FILE: String = "user://messenger_mouse_save_data.json"

var save_data := {
	"version": "0.0.1",
	"secrets": {},
	"cheats": {},
	"levels": {},
	"game_completed": false,
	"next_level_index": 0,
	"play_selected_level": -1,
	"settings": {
		"audio": {}
	}
}

func _ready() -> void:
	load_game()

func save_game() -> void:
	var file: = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file: = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if not file.eof_reached():
		save_data = JSON.parse_string(file.get_line())
	file.close()
