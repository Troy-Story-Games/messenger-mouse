extends Enemy
class_name FlyingEnemy

const EnemyBulletScene = preload("res://game/enemy/enemy_bullet.tscn")
const FlyingEnemyDeathEffectScene = preload("res://game/fx/flying_enemy_death_effect.tscn")
const FlyingEnemySliceDeathEffect = preload("res://game/fx/flying_enemy_slice_death_effect.tscn")

var motion_tween: Tween
var last_bullet: EnemyBullet

@onready var fire_timer: Timer = $FireTimer
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

func _ready() -> void:
    super()
    motion_tween = create_tween()
    motion_tween.tween_property(self, "position", Vector2(position.x, position.y - 5), 0.75)
    motion_tween.chain().tween_property(self, "position", Vector2(position.x, position.y + 5), 0.75)
    motion_tween.set_loops()
    motion_tween.play()

func _on_fire_timer_timeout() -> void:
    var bullet: EnemyBullet = Utils.instantiate_scene_on_level(
        EnemyBulletScene, global_position) as EnemyBullet
    bullet.fire(Vector2.DOWN)
    last_bullet = bullet

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
    _on_fire_timer_timeout()
    fire_timer.start()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
    fire_timer.stop()

func die() -> void:
    var slice_death: EnemySliceDeathEffect = Utils.instantiate_scene_on_level(
        FlyingEnemySliceDeathEffect, global_position) as EnemySliceDeathEffect
    slice_death.scale.x = slice_death.scale.x * sign(sprite_2d.scale.x)
    slice_death.slice(attack_direction)
    var death_effect: AnimatedSpriteEffect = Utils.instantiate_scene_on_level(
        FlyingEnemyDeathEffectScene, global_position) as AnimatedSpriteEffect
    death_effect.play("default")

    # So we don't hit the player with a freshly spawned bullet as they kill the enemy
    if last_bullet and is_instance_valid(last_bullet):
        last_bullet.queue_free()
    super()

func play_death_sound() -> void:
    SoundFx.play("flying_enemy_death", 1.3, -20)
