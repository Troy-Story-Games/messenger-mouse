extends AnimatedSprite2D
class_name AnimatedSpriteEffect

func _ready() -> void:
    animation_finished.connect(queue_free)
