extends Node

const SAVE_FILE: String = "user://messenger_mouse_save_data.json"

var save_data := {
    "version": "0.0.1"
}

func _ready() -> void:
    load_game()

func add_sub_dict(key: String, data: Dictionary) -> void:
    if key in save_data:
        save_data[key].merge(data, true)
    else:
        save_data[key] = data

func add_save_data(data: Dictionary) -> void:
    save_data.merge(data, true)

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
