extends Area2D
class_name Hitbox

signal hit_hurtbox(hurtbox)

@export var damage := 1.0
@export var is_storing_targets: bool = false

var knockback := Vector2.ZERO
var stored_targets := []

func _ready() -> void:
	area_entered.connect(_on_hurtbox_entered)

func clear_stored_targets() -> void:
	stored_targets.clear()

func _on_hurtbox_entered(hurtbox: Hurtbox) -> void:
	if hurtbox.is_invincible:
		return
	if is_storing_targets:
		if hurtbox in stored_targets:
			return
		else:
			stored_targets.append(hurtbox)
	hit_hurtbox.emit(hurtbox)
	hurtbox.hurt.emit(self)
