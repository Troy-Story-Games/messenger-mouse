extends Area2D
class_name Collectible

func collect() -> void:
    SoundFx.play("collect_coin")
    queue_free()
