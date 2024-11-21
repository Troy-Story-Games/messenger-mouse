extends Area2D
class_name Checkpoint

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    animation_player.play("deploy")
    SoundFx.play("checkpoint", 1, -10, 0)
    Events.player_checkpoint.emit(global_position)
    set_deferred("monitoring", false)
