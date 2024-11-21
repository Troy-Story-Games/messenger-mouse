extends Node2D
class_name World

const PlayerScene = preload("res://game/player/player.tscn")

var current_level: Level
var current_level_idx: int = 2
var zoom_out_enabled: bool = false
var last_checkpoint: Vector2

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var ui: UI = $UI

func _ready() -> void:
    ui.start_timer()
    Music.play("song1")
    RenderingServer.set_default_clear_color(Color.BLACK)
    Events.toggle_cheat.connect(_on_toggle_cheat)
    Events.player_checkpoint.connect(_on_player_checkpoint)
    Events.player_died.connect(_on_player_died)
    Events.next_level.connect(_on_next_level)
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
    call_deferred("respawn")

func respawn() -> void:
    var player: Player = PlayerScene.instantiate()
    add_child(player)
    player.global_position = last_checkpoint

func next_level() -> void:
    if current_level_idx >= len(Utils.levels):
        print("End of game... for now wrap around")
        current_level_idx = 0

    if current_level:
        current_level.queue_free()

    current_level = Utils.get_level(current_level_idx).instantiate()
    add_child(current_level)
    last_checkpoint = current_level.start_position.global_position

func _on_next_level() -> void:
    current_level_idx += 1
    call_deferred("next_level")
