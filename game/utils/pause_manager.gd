extends Node
class_name PauseManager

signal paused()
signal unpaused()

var block_unpause: bool = false
var ignore_pause: bool = false
var paused_by_script: bool = false
var is_paused: bool = false :
    set(value):
        is_paused = value
        get_tree().paused = is_paused
        if is_paused:
            paused.emit()
        else:
            unpaused.emit()

func _ready() -> void:
    process_mode = PROCESS_MODE_ALWAYS
    Events.request_script_pause.connect(_on_script_pause)

func _on_script_pause(value: bool) -> void:
    # Don't emit the signal, just pause the game and don't allow unpause
    # by anything except the script
    print("paused by script! ", value)
    if value:
        paused_by_script = true
        get_tree().paused = true
    else:
        paused_by_script = false
        get_tree().paused = false

func _input(event: InputEvent) -> void:
    if block_unpause or ignore_pause:
        return
    if event.is_action_pressed("pause") and not paused_by_script:
        is_paused = not get_tree().paused
