extends Control
class_name MainMenu

var new_game: bool = true

@onready var new_game_continue_button: BeepButton = $CenterContainer/VBoxContainer/NewGameContinueButton
@onready var cheats_button: BeepButton = $CenterContainer/VBoxContainer/CheatsButton
@onready var level_select_button: BeepButton = $CenterContainer/VBoxContainer/LevelSelectButton

func _ready() -> void:
    if not Music.is_playing("main_menu"):
        Music.play("main_menu")
    RenderingServer.set_default_clear_color(Color.BLACK)
    SaveAndLoad.load_game()
    new_game_continue_button.grab_focus()
    level_select_button.hide()
    cheats_button.hide()
    if SaveAndLoad.save_data.next_level_index:
        new_game_continue_button.text = "Continue"
        new_game = false
    if SaveAndLoad.save_data.next_level_index or SaveAndLoad.save_data.game_completed:
        level_select_button.show()
    if SaveAndLoad.save_data.cheats.size():
        cheats_button.show()

func _on_quit_button_pressed() -> void:
    get_tree().quit(0)

func _on_options_button_pressed() -> void:
    get_tree().change_scene_to_file("res://game/ui/options.tscn")

func _on_new_game_continue_button_pressed() -> void:
    if new_game:
        get_tree().change_scene_to_file("res://game/cutscene/cutscenes/intro_cutscene.tscn")
    else:
        get_tree().change_scene_to_file("res://game/world/world.tscn")

func _on_cheats_button_pressed() -> void:
    get_tree().change_scene_to_file("res://game/ui/cheat_code_list_ui.tscn")

func _on_level_select_button_pressed() -> void:
    get_tree().change_scene_to_file("res://game/ui/level_select.tscn")
