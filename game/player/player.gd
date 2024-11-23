extends CharacterBody2D
class_name Player

@export var movement_stats: MovementStats

var direction := Vector2.RIGHT : set = set_direction
var facing_direction := Vector2.RIGHT : set = set_facing_direction
var sprite_shader_material: ShaderMaterial
var long_trail: bool = false

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var flip_anchor: Node2D = $FlipAnchor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var sprite_2d: Sprite2D = $FlipAnchor/Sprite2D
@onready var ceiling_check_ray_cast_2d: RayCast2D = $CeilingCheckRayCast2D
@onready var floor_check_ray_cast_2d: RayCast2D = $FloorCheckRayCast2D
@onready var climb_area_2d: Area2D = $ClimbArea2D
@onready var wall_stick_timer: Timer = $WallStickTimer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var walk_sound_fx: AudioStreamPlayer2D = $WalkSoundFX
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var combo_attack_timer: Timer = $ComboAttackTimer
@onready var collection_area_2d: Area2D = $CollectionArea2D
@onready var hitbox: Hitbox = $FlipAnchor/Hitbox

# FMS Init
@onready var move_state: PlayerMoveState = PlayerMoveState.new().set_actor(self) as PlayerMoveState
@onready var fsm: FSM = FSM.new().set_state(move_state)

# Stats
@onready var stats: Stats = MainInstances.player_stats as Stats

func _enter_tree() -> void:
    MainInstances.player = self

func _exit_tree() -> void:
    MainInstances.player = null

func _ready() -> void:
    assert(movement_stats, "movement_stats must be set")
    Events.request_camera_target.emit.call_deferred(remote_transform_2d)
    hurtbox.hurt.connect(_on_hurtbox_hurt)
    hurtbox.environment_damage.connect(take_environment_hit)
    sprite_shader_material = sprite_2d.material as ShaderMaterial
    sprite_shader_material.set_shader_parameter("nb_frames", Vector2(sprite_2d.hframes, sprite_2d.vframes))
    collection_area_2d.area_entered.connect(collect_item)
    Events.toggle_cheat.connect(_on_toggle_cheat)
    stats.no_health.connect(_on_player_no_health)

func _on_toggle_cheat(cheat_name: String) -> void:
    if cheat_name == "long_trail":
        if not long_trail:
            long_trail = true
            sprite_shader_material.set_shader_parameter("trail_size", 50)
        else:
            long_trail = false
            sprite_shader_material.set_shader_parameter("trail_size", 12)

func _process(_delta: float) -> void:
    sprite_shader_material.set_shader_parameter("frame_coords", sprite_2d.frame_coords)
    sprite_shader_material.set_shader_parameter("velocity", Vector2(abs(velocity.x), velocity.y))

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

func take_environment_hit() -> void:
    take_hit(1)

func _on_hurtbox_hurt(other_hitbox: Hitbox) -> void:
    take_hit(other_hitbox.damage)

func take_hit(damage: float) -> void:
    hurtbox.is_invincible = true
    stats.health -= damage
    Events.player_hurt.emit()
    Events.request_camera_screenshake.emit(4, 0.3)
    await get_tree().create_timer(0.5).timeout
    hurtbox.is_invincible = false

func _on_player_no_health() -> void:
    die()

func die() -> void:
    Events.player_died.emit()
    queue_free()  # TODO: Death effect

func collect_item(item: Collectible) -> void:
    item.collect()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    die()

func is_ceiling_raycast_colliding() -> bool:
    return ceiling_check_ray_cast_2d.is_colliding()

func is_floor_raycast_colliding() -> bool:
    return floor_check_ray_cast_2d.is_colliding()
