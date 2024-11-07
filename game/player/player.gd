extends CharacterBody2D
class_name Player

@export var movement_stats: MovementStats

var direction := Vector2.RIGHT : set = set_direction
var facing_direction := Vector2.RIGHT : set = set_facing_direction

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var flip_anchor: Node2D = $FlipAnchor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Hurtbox = $FlipAnchor/Hurtbox
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_collision_shape_2d: CollisionShape2D = $FlipAnchor/Hurtbox/CollisionShape2D

# FMS Init
@onready var move_state: PlayerMoveState = PlayerMoveState.new().set_actor(self) as PlayerMoveState
@onready var fsm: FSM = FSM.new().set_state(move_state)

func _enter_tree() -> void:
    MainInstances.player = self

func _exit_tree() -> void:
    MainInstances.player = null

func _ready() -> void:
    assert(movement_stats, "movement_stats must be set")
    Events.request_camera_target.emit.call_deferred(remote_transform_2d)
    hurtbox.hurt.connect(take_hit)

func _physics_process(delta: float) -> void:
    fsm.state.process_state(delta)

func set_direction(value: Vector2) -> void:
    if value == Vector2.ZERO:
        return
    value = value.normalized()
    direction = value

func set_facing_direction(value: Vector2) -> void:
    if value == Vector2.ZERO:
        return
    value = value.normalized()
    value = Vector2(sign(value.x), 0)
    facing_direction = value

func take_hit(other_hitbox: Hitbox) -> void:
    print("take_hit()")
    hurtbox.is_invincible = true
    Events.request_camera_screenshake.emit(4, 0.3)
    await get_tree().create_timer(0.5).timeout
    hurtbox.is_invincible = false
