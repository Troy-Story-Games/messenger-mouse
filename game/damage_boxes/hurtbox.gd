extends Area2D
class_name Hurtbox

signal hurt(hitbox: Hitbox)

var is_invincible := false :
    set(value):
        is_invincible = value
        set_deferred("monitoring", not is_invincible)
