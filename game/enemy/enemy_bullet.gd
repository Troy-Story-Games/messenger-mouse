extends CharacterBody2D
class_name EnemyBullet

## Bullet speed
@export var speed = 150.0

var direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D

func fire(dir: Vector2) -> void:
    SoundFx.play_2d("enemy_shoot", global_position)
    direction = dir

func _physics_process(delta: float) -> void:
    if direction == Vector2.ZERO:
        return
    velocity = direction * speed * delta
    var collision: KinematicCollision2D = move_and_collide(velocity)
    if collision:
        queue_free()

func _on_hitbox_hit_hurtbox(_hurtbox: Variant) -> void:
    SoundFx.play("bullet_hit")
    queue_free()
