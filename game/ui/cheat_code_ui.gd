extends Control
class_name CheatCodeUI

signal cheat_code_ui_closed()

var viewed_long_enough: bool = false

@export var handle_pause: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cheat_title_label: Label = $CenterContainer/HBoxContainer/CheatTitleLabel
@onready var cheat_code_label: Label = $CenterContainer/HBoxContainer/CheatCodeLabel
@onready var viewed_long_enough_label: Label = $CenterContainer/HBoxContainer/ViewedLongEnoughLabel
@onready var timer: Timer = $Timer

func _ready() -> void:
    viewed_long_enough = false
    hide()

func display_cheat_code_from_dict(cheat_code: Dictionary) -> void:
    show()
    viewed_long_enough = false
    animation_player.play("show")
    if handle_pause:
        MainInstances.pause_manager.ignore_pause = true
        Events.request_script_pause.emit(true)
    cheat_title_label.text = cheat_code.name
    cheat_code_label.text = Utils.generate_cheat_string(cheat_code.button_combo)

func display_cheat_code(cheat_code: CheatCode) -> void:
    var dict = {
        "button_combo": cheat_code.button_combo,
        "name": cheat_code.cheat_name
    }
    display_cheat_code_from_dict(dict)

func _process(_delta: float) -> void:
    if viewed_long_enough:
        if Input.get_connected_joypads():
            viewed_long_enough_label.text = "pause/start to continue"
        else:
            viewed_long_enough_label.text = "ESC to continue"
        return
    var show_time = 4
    if not timer.is_stopped():
        show_time = timer.time_left
    viewed_long_enough_label.text = "Look! %02d" % show_time

func _input(event: InputEvent) -> void:
    if not visible:
        return
    if not viewed_long_enough:
        return

    if event.is_action_pressed("pause"):
        animation_player.play(&"RESET")
        hide()
        viewed_long_enough = false
        if handle_pause:
            Events.request_script_pause.emit(false)
        cheat_code_ui_closed.emit()

        if handle_pause:
            await get_tree().create_timer(0.2).timeout
            MainInstances.pause_manager.ignore_pause = false

func _on_timer_timeout() -> void:
    viewed_long_enough = true
