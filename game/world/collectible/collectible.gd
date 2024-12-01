extends Area2D
class_name Collectible

var start_visible: bool

@export var time_value: float = 0.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
    start_visible = visible
    Events.player_died.connect(_on_player_died)

func collect() -> void:
    SoundFx.play("collect_coin", 1, -20.0)
    Events.flame_collected.emit()
    start_visible = true
    hide()
    collision_shape_2d.set_deferred("disabled", true)

func _on_player_died() -> void:
    collision_shape_2d.set_deferred("disabled", false)
    if start_visible:
        show()
