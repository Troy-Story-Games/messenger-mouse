extends Control
class_name Leaderboard

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton

func _ready() -> void:
    back_button.grab_focus()

func _input(event: InputEvent) -> void:
    if not event is InputEventKey:
        return

    var key_event: InputEventKey = event as InputEventKey
    if key_event.keycode == KEY_ESCAPE:
        go_back()

func go_back() -> void:
    get_tree().change_scene_to_file("res://game/ui/main_menu.tscn")

func _on_back_button_pressed() -> void:
    go_back()
