extends CharacterBody2D
class_name Enemy

signal died()

## Enemy health stats
@export var stats: Stats
## Bounces you up when killing
@export var bouncy_enemy: bool = false
## Can be killed with head jump
@export var head_kill_enemy: bool = false

var attack_direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    assert(stats, "Missing enemy stats")
    hurtbox.hurt.connect(take_hit)
    stats.no_health.connect(die)

func take_hit(hitbox: Hitbox) -> void:
    attack_direction = hitbox.knockback
    stats.health -= hitbox.damage

func play_death_sound() -> void:
    SoundFx.play("enemy_death")

func die() -> void:
    play_death_sound()
    Events.enemy_killed.emit(self)
    died.emit()
    queue_free()

func squish_animation() -> void:
    pass

func disable_hit_hurt() -> void:
    hurtbox.set_deferred("monitoring", false)
    hurtbox.set_deferred("monitorable", false)
    hitbox.set_deferred("monitoring", false)
    hitbox.set_deferred("monitorable", false)

func enable_hit_hurt() -> void:
    hurtbox.set_deferred("monitoring", true)
    hurtbox.set_deferred("monitorable", true)
    hitbox.set_deferred("monitoring", true)
    hitbox.set_deferred("monitorable", true)

func squish() -> void:
    animation_player.stop(true)
    set_physics_process(false)
    SoundFx.play("enemy_head_stomp")
    disable_hit_hurt()
    await squish_animation()
    Events.enemy_killed.emit(self)
    died.emit()
    queue_free()
