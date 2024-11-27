extends Node

const SAVE_FILE: String = "user://messenger_mouse_save_data.json"

var save_data := {
    "version": "0.0.1",
    "secrets": {},
    "cheats": {},
    "levels": {},
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

func quit_game(exit_code: int = 0) -> void:
    save_game()
    get_tree().quit(exit_code)
