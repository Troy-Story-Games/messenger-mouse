extends Enemy
class_name FlyingEnemy

const EnemyBulletScene = preload("res://game/enemy/enemy_bullet.tscn")

var motion_tween: Tween

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
    var bullet: EnemyBullet = Utils.instantiate_scene_on_level(EnemyBulletScene, global_position) as EnemyBullet
    bullet.fire(Vector2.DOWN)

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
    _on_fire_timer_timeout()
    fire_timer.start()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
    fire_timer.stop()
