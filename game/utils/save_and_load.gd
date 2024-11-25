extends Node

const SAVE_FILE: String = "user://messenger_mouse_save_data.json"

var custom_data := {
    "version": "0.0.1",
}

func _ready():
    load_game()

func save_game():
    var file: = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    file.store_line(JSON.stringify(custom_data))
    file.close()

func load_game():
    if not FileAccess.file_exists(SAVE_FILE):
        return
    var file: = FileAccess.open(SAVE_FILE, FileAccess.READ)
    if not file.eof_reached():
        custom_data = JSON.parse_string(file.get_line())
    file.close()
