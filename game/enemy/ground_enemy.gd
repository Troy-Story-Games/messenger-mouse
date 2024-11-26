extends Enemy
class_name GroundEnemy

const SquishDustEffectScene = preload("res://game/fx/squish_dust_effect.tscn")

@export var speed: = 75.0
@export var fall_speed: = 150.0

var direction = Vector2.LEFT

@onready var left_floor_ray_cast_2d: RayCast2D = $LeftFloorRayCast2D
@onready var right_floor_ray_cast_2d_2: RayCast2D = $RightFloorRayCast2D2
@onready var squish_animation_player: AnimationPlayer = $SquishAnimationPlayer

func _ready() -> void:
    super()
    set_physics_process(false)

func _physics_process(_delta: float) -> void:
    if not is_on_floor():
        velocity.y += fall_speed
        move_and_slide()
        return

    velocity.x = sign(direction.x) * speed
    sprite_2d.scale.x = abs(sprite_2d.scale.x) * sign(velocity.x)

    if not left_floor_ray_cast_2d.is_colliding():
        direction = Vector2.RIGHT
    elif not right_floor_ray_cast_2d_2.is_colliding():
        direction = Vector2.LEFT

    move_and_slide()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
    set_physics_process(true)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
    set_physics_process(false)

func squish_animation() -> void:
    Utils.instantiate_scene_on_level(SquishDustEffectScene, global_position).play("default")
    if sprite_2d.scale.x < 0:
        squish_animation_player.play("squish_left")
    else:
        squish_animation_player.play("squish_right")
    await squish_animation_player.animation_finished
