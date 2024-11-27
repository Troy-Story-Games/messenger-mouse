extends Node2D
class_name World

const PlayerScene = preload("res://game/player/player.tscn")

@export var min_time_left_on_respawn: float = 15.0

var current_level: Level
var current_level_idx: int = 4
var zoom_out_enabled: bool = false
var last_checkpoint: Vector2

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var ui: UI = $UI

func _ready() -> void:
    Events.toggle_cheat.connect(_on_toggle_cheat)
    Events.player_checkpoint.connect(_on_player_checkpoint)
    Events.player_died.connect(_on_player_died)
    Events.next_level.connect(_on_next_level)
    Events.level_timeout.connect(_on_level_timeout)
    call_deferred("next_level")

func _on_player_checkpoint(checkpoint_pos: Vector2) -> void:
    last_checkpoint = checkpoint_pos

func _on_toggle_cheat(cheat_name: String):
    if cheat_name == "zoom_out":
        if not zoom_out_enabled:
            zoom_out_enabled = true
            player_camera.zoom = Vector2(0.4, 0.4)
        else:
            zoom_out_enabled = false
            player_camera.zoom = Vector2(1, 1)

func _on_player_died() -> void:
    var time_left = current_level.get_time_left()
    if time_left < min_time_left_on_respawn:
        current_level.set_time_left(min_time_left_on_respawn)
    call_deferred("respawn")

func _on_level_timeout() -> void:
    print("LEVEL TIMEOUT!")
    call_deferred("next_level")

func respawn() -> void:
    print_debug("respawn player at ", last_checkpoint)
    var player: Player = PlayerScene.instantiate()
    add_child(player)
    player.global_position = last_checkpoint

func next_level() -> void:
    if current_level_idx >= len(Utils.levels):
        # TODO: Win - credits
        print("End of game... for now wrap around")
        current_level_idx = 0

    if current_level:
        current_level.queue_free()

    current_level = Utils.get_level(current_level_idx).instantiate()
    add_child(current_level)
    last_checkpoint = current_level.start_position.global_position

    if current_level_idx == 0:
        await get_tree().create_timer(0.5).timeout
        ui.show_tutorial()
        get_tree().paused = true
        await ui.ui_tutorial_complete
        get_tree().paused = false

    start_level()

func start_level() -> void:
    ui.start_timer()
    ui.set_total_cheats(current_level.get_num_cheats())
    ui.set_total_secrets(current_level.get_num_secrets())
    ui.set_flame_progress_max(current_level.time_limit)

func _on_next_level() -> void:
    current_level_idx += 1
    call_deferred("next_level")

func _process(_delta: float) -> void:
    var time_left = current_level.get_time_left()
    ui.set_flame_progress(time_left)
