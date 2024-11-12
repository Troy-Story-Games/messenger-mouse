extends Node2D
class_name Level

var initialized: bool = false : set = set_initialized

@onready var start_position: Marker2D = $StartPosition

func _physics_process(_delta: float) -> void:
    if initialized:
        return

    var player: = MainInstances.player as Player
    if not player or not is_instance_valid(player):
        return

    initialized = true
    player.global_position = start_position.global_position

func set_initialized(value: bool) -> void:
    initialized = value
    set_physics_process(not value)
