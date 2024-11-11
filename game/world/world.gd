extends Node2D
class_name World

var current_level: Level
var zoom_out_enabled: bool = false

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var ui: UI = $UI

func _ready() -> void:
    ui.start_timer()
    Music.play("song1")
    current_level = $Level01
    RenderingServer.set_default_clear_color(Color.BLACK)
    Events.toggle_cheat.connect(_on_toggle_cheat)

func _on_toggle_cheat(cheat_name: String):
    if cheat_name == "zoom_out":
        if not zoom_out_enabled:
            zoom_out_enabled = true
            player_camera.zoom = Vector2(0.4, 0.4)
        else:
            zoom_out_enabled = false
            player_camera.zoom = Vector2(1, 1)
