extends Enemy
class_name GroundEnemy

const SquishDustEffectScene = preload("res://game/fx/squish_dust_effect.tscn")
const GroundEnemySliceDeathEffectScene = preload("res://game/fx/ground_enemy_slice_death_effect.tscn")
const EnemyBloodDeathEffectScene = preload("res://game/fx/enemy_blood_death_effect.tscn")

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

	if not left_floor_ray_cast_2d.is_colliding():
		direction = Vector2.RIGHT
	elif not right_floor_ray_cast_2d_2.is_colliding():
		direction = Vector2.LEFT
	elif is_on_wall() and is_on_floor():
		direction.x = direction.x * -1

	velocity.x = sign(direction.x) * speed
	sprite_2d.scale.x = abs(sprite_2d.scale.x) * sign(velocity.x)
	move_and_slide()

func die() -> void:
	var slice_effect: EnemySliceDeathEffect = Utils.instantiate_scene_on_level(GroundEnemySliceDeathEffectScene, global_position)
	slice_effect.scale.x = slice_effect.scale.x * sign(sprite_2d.scale.x)
	slice_effect.slice(attack_direction)

	#var blood_effect: AnimatedSpriteEffect = Utils.instantiate_scene_on_level(EnemyBloodDeathEffectScene, global_position)
	#blood_effect.play("default")
	super()

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
