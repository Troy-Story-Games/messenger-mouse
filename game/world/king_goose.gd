extends CharacterBody2D
class_name KingGoose

@export var speed: = 75.0
@export var fall_speed: = 150.0

var direction = Vector2.LEFT

@onready var left_floor_ray_cast_2d: RayCast2D = $LeftFloorRayCast2D
@onready var right_floor_ray_cast_2d: RayCast2D = $RightFloorRayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("walk")

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += fall_speed
		move_and_slide()
		return

	if not left_floor_ray_cast_2d.is_colliding():
		direction = Vector2.RIGHT
	elif not right_floor_ray_cast_2d.is_colliding():
		direction = Vector2.LEFT
	elif is_on_wall() and is_on_floor():
		direction.x = direction.x * -1

	velocity.x = sign(direction.x) * speed
	sprite_2d.scale.x = abs(sprite_2d.scale.x) * sign(velocity.x)
	move_and_slide()
