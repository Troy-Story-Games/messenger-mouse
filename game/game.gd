extends Node2D
class_name World

@onready var ui: UI = $UI

func _ready() -> void:
    ui.start_timer()
