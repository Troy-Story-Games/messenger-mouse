extends Area2D
class_name Checkpoint

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    Events.player_checkpoint.emit(global_position)
    set_deferred("monitoring", false)
