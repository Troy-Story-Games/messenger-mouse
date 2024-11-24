extends Control
class_name MainMenu

@onready var new_game_continue: Button = $CenterContainer/VBoxContainer/NewGameContinue

func _ready() -> void:
    if not Music.is_playing("song1"):
        Music.play("song1")
    RenderingServer.set_default_clear_color(Color.BLACK)
    SaveAndLoad.load_game()
    new_game_continue.grab_focus()
    # TODO: Change new game to continue if there's save data

func _on_new_game_continue_pressed() -> void:
    get_tree().change_scene_to_file("res://game/world/world.tscn")

func _on_options_pressed() -> void:
    get_tree().change_scene_to_file("res://game/ui/options.tscn")

func _on_quit_pressed() -> void:
    get_tree().quit(0)
