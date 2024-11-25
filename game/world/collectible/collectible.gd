extends Area2D
class_name Collectible

@export var time_value: float = 0.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
    Events.player_died.connect(_on_player_died)

func collect() -> void:
    SoundFx.play("collect_coin")
    hide()
    collision_shape_2d.set_deferred("disabled", true)

func _on_player_died() -> void:
    collision_shape_2d.set_deferred("disabled", false)
    show()
