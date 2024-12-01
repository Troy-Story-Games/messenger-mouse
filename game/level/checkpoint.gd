extends Area2D
class_name Checkpoint

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(_area: Area2D) -> void:
    animation_player.play("deploy")
    SoundFx.play("checkpoint", 1, -12.0, 0)
    print("emitting player checkpoint: ", global_position)
    Events.player_checkpoint.emit(global_position)
    set_deferred("monitoring", false)
