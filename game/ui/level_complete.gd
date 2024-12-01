extends Control
class_name LevelComplete

signal next_level()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: BeepButton = $CenterContainer/VBoxContainer/ContinueButton
@onready var secrets: Label = $CenterContainer/VBoxContainer/HBoxContainer/SecretsAndCheats/Secrets
@onready var cheats: Label = $CenterContainer/VBoxContainer/HBoxContainer/SecretsAndCheats/Cheats
@onready var best_time: Label = $CenterContainer/VBoxContainer/HBoxContainer/Times/BestTime
@onready var current_time: Label = $CenterContainer/VBoxContainer/HBoxContainer/Times/CurrentTime
@onready var level_name: Label = $CenterContainer/VBoxContainer/LevelName

func _ready() -> void:
    hide()
    continue_button.disabled = true
    Events.next_level.connect(_on_next_level)

func _on_next_level(stats: Dictionary):
    show()

    var current_level: Level = MainInstances.current_level
    if current_level and is_instance_valid(current_level) and current_level.level_name:
        level_name.text = current_level.level_name

    # Show stats
    best_time.text = "Best Time: " + Utils.ms_to_string(stats.best_time)
    current_time.text = "Time: " + Utils.ms_to_string(stats.last_time)
    secrets.text = "Secrets: %02d/%02d" % [stats.secrets_found, stats.num_secrets]
    cheats.text = "Cheats: %02d/%02d" % [stats.cheats_found, stats.num_cheats]

    continue_button.disabled = false
    continue_button.grab_focus()
    animation_player.play("show")
    get_tree().set_deferred("paused", true)

func hide_menu() -> void:
    Events.request_script_pause.emit(false)
    hide()
    animation_player.play(&"RESET")
    continue_button.disabled = true

func _on_continue_button_pressed() -> void:
    hide_menu()
    next_level.emit()

func _on_save_and_quit_button_pressed() -> void:
    SaveAndLoad.save_game()
    get_tree().quit(0)

func _on_stay_here_button_pressed() -> void:
    Events.level_stay_here.emit()
    hide_menu()

func _on_main_menu_button_pressed() -> void:
    SaveAndLoad.save_data.next_level_index = SaveAndLoad.save_data.next_level_index + 1
    SaveAndLoad.save_game()
    Events.request_script_pause.emit(false)
    get_tree().change_scene_to_file("res://game/ui/main_menu.tscn")
