extends Node2D
class_name EnemySliceDeathEffect

@export var impulse_strength: float = 500.0
@export var top_collision_shape: PackedVector2Array
@export var bottom_collision_shape: PackedVector2Array
@export var left_collision_shape: PackedVector2Array
@export var right_collision_shape: PackedVector2Array

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var top: Sprite2D = $Half1/Top
@onready var left: Sprite2D = $Half1/Left
@onready var bottom: Sprite2D = $Half2/Bottom
@onready var right: Sprite2D = $Half2/Right
@onready var half_1: RigidBody2D = $Half1
@onready var half_2: RigidBody2D = $Half2
@onready var collision_poly_half1: CollisionPolygon2D = $Half1/CollisionShape2D
@onready var collision_poly_half2: CollisionPolygon2D = $Half2/CollisionShape2D

func _ready() -> void:
    top.hide()
    left.hide()
    bottom.hide()
    right.hide()
    animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: String):
    queue_free()

func slice(attack_direction: Vector2) -> void:
    print(attack_direction)
    animation_player.play("fade_out")
    if attack_direction == Vector2.UP or attack_direction == Vector2.DOWN:
        left.show()
        right.show()
        collision_poly_half1.set_deferred("polygon", left_collision_shape)
        collision_poly_half2.set_deferred("polygon", right_collision_shape)
        half_1.apply_central_impulse(Vector2.LEFT * impulse_strength)
        half_2.apply_central_impulse(Vector2.RIGHT * impulse_strength)
    else:
        top.show()
        bottom.show()
        collision_poly_half1.set_deferred("polygon", top_collision_shape)
        collision_poly_half2.set_deferred("polygon", bottom_collision_shape)
        half_1.apply_central_impulse(Vector2.UP * impulse_strength / 2)
        half_2.apply_central_impulse(Vector2.DOWN * impulse_strength / 2)
        if attack_direction == Vector2.LEFT:
            half_1.apply_central_impulse(Vector2.LEFT * impulse_strength)
            half_2.apply_central_impulse(Vector2.LEFT * impulse_strength)
        else:
            half_1.apply_central_impulse(Vector2.RIGHT * impulse_strength)
            half_2.apply_central_impulse(Vector2.RIGHT * impulse_strength)
