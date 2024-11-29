extends RigidBody2D
class_name Campfire

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    sprite_2d.frame = 0

func set_progress(value: float):
    sprite_2d.frame = int(sprite_2d.hframes * value)
    if value >= 1.0:
        animation_player.play("burn")
