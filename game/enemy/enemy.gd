extends CharacterBody2D
class_name Enemy

@onready var hurtbox: Hurtbox = $Hurtbox

func _ready():
    hurtbox.hurt.connect(take_hit)

func take_hit(_hitbox: Hitbox):
    queue_free()
