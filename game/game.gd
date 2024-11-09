extends Node2D
class_name World

var current_level: Level

@onready var ui: UI = $UI

func _ready() -> void:
    ui.start_timer()
    Music.play("song1")
    current_level = $Level01
