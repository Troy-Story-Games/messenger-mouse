extends Control
class_name Options

var animation_list: Array[String] = ["idle", "walk", "run", "jump", "fall", "double_jump", "slide", "launch"]

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var animated_sprite_2d: AnimatedSprite2D = $VBoxContainer/MarginContainer2/TabContainer/Controls/ControlsPanel/HBoxContainer/AnimatedSprite/AnimatedSprite2D

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

func _on_timer_timeout() -> void:
    var old = animation_list.pop_front()
    animation_list.append(old)
    animated_sprite_2d.play(animation_list[0])
