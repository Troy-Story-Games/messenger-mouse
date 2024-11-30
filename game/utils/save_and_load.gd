extends Node

const SAVE_FILE: String = "user://messenger_mouse_save_data.json"
const CURRENT_SAVE_FILE_VERSION = "1.0.0"

var default_save_data := {
    "version": "1.0.0",
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

var save_data: Dictionary = {}

func _ready() -> void:
    save_data = default_save_data.duplicate(true)
    load_game()

func save_game() -> void:
    var file: = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    file.store_line(JSON.stringify(save_data))
    file.close()

func check_save(save_data: Dictionary) -> bool:
    if save_data and "version" in save_data and save_data.version == CURRENT_SAVE_FILE_VERSION:
        return true

    push_error("The save file at " + SAVE_FILE + " is invalid, corrupt, or out of date. Backing up to " + SAVE_FILE + ".bak and generating a new one.")
    var error = DirAccess.rename_absolute(SAVE_FILE, SAVE_FILE + ".bak")
    assert(error == OK, "Unable to backup old/corrupt config. Cannot continue")
    return false


func load_game() -> void:
    if not FileAccess.file_exists(SAVE_FILE):
        return
    var file: = FileAccess.open(SAVE_FILE, FileAccess.READ)
    if not file.eof_reached():
        save_data = JSON.parse_string(file.get_line())
        file.close()
        if not check_save(save_data):
            save_data = default_save_data.duplicate(true)
    else:
        push_error("Empty save file!")
        file.close()
