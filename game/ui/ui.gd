extends CanvasLayer
class_name UI

const FLAME_SHAKE_THRESHOLD: = 20.0

signal ui_tutorial_complete()

var time_ms: = 0.0 : set = set_time_ms
var total_cheats: int = 0 : set = set_total_cheats
var total_secrets: int = 0 : set = set_total_secrets
var cheats_found: int = 0 : set = set_cheats_found
var secrets_found: int = 0 : set = set_secrets_found

@onready var secrets_found_label: Label = $Control/Secrets/HBoxContainer/SecretsFoundLabel
@onready var cheats_found_label: Label = $Control/Cheats/HBoxContainer/CheatsFoundLabel
@onready var clock: Label = $Control/Timer/Clock
@onready var tutorial: MarginContainer = $Control/Tutorial
@onready var tutorial_animation_player: AnimationPlayer = $TutorialAnimationPlayer
@onready var flame_progress_bar: ProgressBar = $Control/Flame/HBoxContainer/MarginContainer/FlameProgressBar
@onready var progress_bar_flame_sprite_2d: Sprite2D = $Control/Flame/HBoxContainer/Control/Control/ProgressBarFlameSprite2D

func set_flame_progress_max(value: float) -> void:
    flame_progress_bar.max_value = value

func set_flame_progress(value: float) -> void:
    flame_progress_bar.value = value

func show_tutorial() -> void:
    tutorial_animation_player.play("tutorial")

func tutorial_finished() -> void:
    ui_tutorial_complete.emit()

func tutorial_step() -> void:
    SoundFx.play("ui_tutorial_step")

func tutorial_go() -> void:
    SoundFx.play("tutorial_go_sound")

func update_cheats_label() -> void:
    cheats_found_label.text = "%02d/%02d" % [cheats_found, total_cheats]

func update_secrets_label() -> void:
    secrets_found_label.text = "%02d/%02d" % [secrets_found, total_secrets]

func set_cheats_found(value: int) -> void:
    cheats_found = value
    update_cheats_label()

func set_secrets_found(value: int) -> void:
    secrets_found = value
    update_secrets_label()

func set_total_cheats(value: int) -> void:
    total_cheats = value
    update_cheats_label()

func set_total_secrets(value: int) -> void:
    total_secrets = value
    update_secrets_label()

func set_time_ms(value: float) -> void:
    time_ms = value
    clock.text = Utils.ms_to_string(time_ms)

func _on_flame_shake_timer_timeout() -> void:
    var percentage: float = (flame_progress_bar.value / flame_progress_bar.max_value) * 100.0
    if percentage <= FLAME_SHAKE_THRESHOLD:
        progress_bar_flame_sprite_2d.scale.x = randf_range(0.75, 1.25)
        progress_bar_flame_sprite_2d.scale.y = randf_range(0.75, 1.25)
    else:
        progress_bar_flame_sprite_2d.scale = Vector2.ONE
