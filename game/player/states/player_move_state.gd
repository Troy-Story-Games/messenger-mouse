extends State
class_name PlayerMoveState

const COYOTE_JUMP_REACTION_TIME: = 0.2

signal slide()
signal crouch()

var just_jumped: bool = false
var double_jump: bool = true
var coyote_jump_timer: SceneTreeTimer

func get_input_vector(player: Player) -> Vector2:
    var input_vector: = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    player.facing_direction = input_vector
    player.direction = input_vector
    return input_vector.normalized()

func jump(player: Player, force: float) -> void:
    player.velocity.y = -force

func jump_check(player: Player) -> void:
    var jump_just_pressed: bool = Input.is_action_just_pressed("jump")
    var jump_just_released: bool = Input.is_action_just_released("jump")
    if player.is_on_wall_only() and jump_just_pressed:
        # Wall jump
        player.velocity.x = player.get_wall_normal().x * player.movement_stats.wall_jump_speed
        jump(player, player.movement_stats.wall_jump_force)
        just_jumped = true
    elif (player.is_on_floor() or (coyote_jump_timer and coyote_jump_timer.time_left > 0)) and jump_just_pressed:
        # Regular jump
        print("regular")
        if coyote_jump_timer and coyote_jump_timer.time_left > 0:
            print("coyote saved you")
        jump(player, player.movement_stats.ground_jump_force)
        just_jumped = true
    else:
        if jump_just_released and player.velocity.y < -player.movement_stats.ground_jump_force / 2:
            player.velocity.y = -player.movement_stats.ground_jump_force / 2

        if jump_just_pressed and double_jump == true:
            # Handle double jump
            print("double")
            jump(player, player.movement_stats.air_jump_force)
            double_jump = false

func apply_horizontal_force(player: Player, input_vector: Vector2, delta: float) -> void:
    var accel: = player.movement_stats.ground_acceleration
    var friction: = player.movement_stats.ground_friction
    var speed: = player.movement_stats.ground_max_speed
    if not player.is_on_floor() and not player.is_on_wall():  # Air
        accel = player.movement_stats.air_acceleration
        friction = player.movement_stats.air_friction
        speed = player.movement_stats.air_max_speed

    if input_vector != Vector2.ZERO:
        var new_velocity: = player.direction * speed
        player.velocity = player.velocity.move_toward(new_velocity, accel * delta)
    else:
        player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)

func apply_gravity(player: Player, delta: float) -> void:
    player.velocity.y += player.movement_stats.gravity * delta
    player.velocity.y = min(player.velocity.y, player.movement_stats.terminal_velocity)

func move(player: Player):
    var was_in_air: = not player.is_on_floor()
    var was_on_floor: = player.is_on_floor()
    var last_velocity: = Vector2(player.velocity)
    var last_position: = player.position

    player.move_and_slide()

    # Happens on landing
    if was_in_air and player.is_on_floor():
        print("land")
        # On landing we get double jump back
        double_jump = true

    # Just left the ground
    if was_on_floor and not player.is_on_floor() and not just_jumped:
        coyote_jump_timer = player.get_tree().create_timer(COYOTE_JUMP_REACTION_TIME)

func update_animations(player: Player, input_vector: Vector2) -> void:
    if player.facing_direction.x != 0:
        player.flip_anchor.scale.x = sign(player.facing_direction.x)

    if not player.is_on_floor() and not player.is_on_wall():
        player.animation_player.play("jump")
    elif input_vector != Vector2.ZERO and player.is_on_floor():
        player.animation_player.play("run")
    elif player.is_on_floor():
        player.animation_player.play("idle")

func process_state(delta: float) -> void:
    just_jumped = false
    var player: = actor as Player
    var input_vector: = get_input_vector(player)

    apply_horizontal_force(player, input_vector, delta)
    jump_check(player)
    apply_gravity(player, delta)
    update_animations(player, input_vector)
    move(player)
    #wall_slide_check()
