extends CharacterBody2D
class_name Enemy

signal died()

## Enemy health stats
@export var stats: Stats
## Bounces you up when killing
@export var bouncy_enemy: bool = false
## Can be killed with head jump
@export var head_kill_enemy: bool = false

var spawn_point: Vector2

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
    assert(stats, "Missing enemy stats")
    spawn_point = global_position
    hurtbox.hurt.connect(take_hit)
    stats.no_health.connect(die)

func take_hit(hitbox: Hitbox) -> void:
    stats.health -= hitbox.damage

func die() -> void:
    Events.enemy_killed.emit(self)
    died.emit()
    queue_free()
