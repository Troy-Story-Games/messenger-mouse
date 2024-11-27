extends Area2D
class_name Hurtbox

signal hurt(hitbox: Hitbox)
signal environment_damage()

var is_invincible := false :
    set(value):
        is_invincible = value
        set_deferred("monitoring", not is_invincible)

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    environment_damage.emit()
