extends Area2D
class_name Checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    print("hello?")
    if body is Player:
        print("FUCK")
        Events.player_checkpoint.emit(global_position)
        set_deferred("monitoring", false)
