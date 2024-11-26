extends CanvasLayer
class_name UI

signal ui_tutorial_complete()

var running: bool = false
var time_ms: = 0.0 : set = set_time_ms

@onready var secrets_found_label: Label = $Control/Secrets/HBoxContainer/SecretsFoundLabel
@onready var cheats_found_label: Label = $Control/Cheats/HBoxContainer/CheatsFoundLabel
@onready var clock: Label = $Control/Timer/Clock
@onready var tutorial: MarginContainer = $Control/Tutorial
@onready var tutorial_animation_player: AnimationPlayer = $TutorialAnimationPlayer

func start_timer() -> void:
    time_ms = 0.0
    running = true

func stop_timer() -> float:
    var ret: = time_ms
    time_ms = 0.0
    running = false
    return ret

func show_tutorial() -> void:
    tutorial_animation_player.play("tutorial")

func tutorial_finished() -> void:
    ui_tutorial_complete.emit()

func tutorial_step() -> void:
    SoundFx.play("ui_tutorial_step")

func set_total_cheats(count: int) -> void:
    pass

func set_total_secrets(count: int) -> void:
    pass

func _process(delta: float) -> void:
    if not running:
        return
    time_ms += delta * 1000

func set_time_ms(value: float) -> void:
    time_ms = value
    var rem_ms: = time_ms
    var rem_m: = int(floor((rem_ms / 1000.0) / 60.0))
    rem_ms -= rem_m * 60 * 1000
    var rem_s: = int(floor(rem_ms / 1000.0))
    rem_ms -= rem_s * 1000
    clock.text = "%02d:%02d:%02d" % [rem_m, rem_s, int(floor(rem_ms / 10.0))]
