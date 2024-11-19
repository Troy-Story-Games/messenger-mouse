extends Node2D
class_name Level

var initialized: bool = false : set = set_initialized
var exiting: bool = false

@onready var start_position: Marker2D = $StartPosition
@onready var level_exit: Area2D = $LevelExit

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


func _on_level_exit_area_entered(area: Area2D) -> void:
    if not exiting:
        exiting = true
        Events.next_level.emit()
        level_exit.set_deferred("monitoring", false)
        level_exit.set_deferred("monitorable", false)
