extends Node2D
class_name World

const PlayerScene = preload("res://game/player/player.tscn")

var current_level: Level
var zoom_out_enabled: bool = false
var last_checkpoint: Vector2

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var ui: UI = $UI

func _ready() -> void:
    ui.start_timer()
    Music.play("song1")
    current_level = $Level01
    last_checkpoint = current_level.start_position.global_position
    RenderingServer.set_default_clear_color(Color.BLACK)
    Events.toggle_cheat.connect(_on_toggle_cheat)
    Events.player_checkpoint.connect(_on_player_checkpoint)
    Events.player_died.connect(_on_player_died)

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
    var player: Player = PlayerScene.instantiate()
    add_child(player)
    player.global_position = last_checkpoint
