extends State
class_name PlayerMoveState

signal slide()
signal crouch()

var just_jumped: bool = false
var double_jump: bool = true
var coyote_jump_timer: Timer

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
        jump(player, player.movement_stats.ground_jump_force)
        just_jumped = true
    else:
        if jump_just_released and player.velocity.y < -player.movement_stats.ground_jump_force / 2:
            player.velocity.y = -player.movement_stats.ground_jump_force / 2

        if jump_just_pressed and double_jump == true:
            # Handle double jump
            jump(player, player.movement_stats.air_jump_force)
            double_jump = false

func apply_horizontal_force(player: Player, delta: float) -> void:
    if player.input_vector != Vector2.ZERO:
        var new_velocity = player.direction * player.movement_stats.ground_max_speed
        player.velocity = player.velocity.move_toward(new_velocity, player.movement_stats.ground_acceleration * delta)
    else:
        player.velocity = player.velocity.move_toward(Vector2.ZERO, player.movement_stats.ground_friction * delta)

func process_state(delta: float) -> void:
    var player: = actor as Player
    var input_vector: = get_input_vector(player)

    apply_horizontal_force(player, delta)
    jump_check(player)
    apply_gravity(delta)
    update_animations(input_vector)
    move()
    wall_slide_check()
    double_press_check()
    dig_check()

    # Handle horizontal velocity
    

    # Gravity
    player.velocity.y += player.movement_stats.gravity * delta
    player.velocity.y = min(player.velocity.y, player.movement_stats.terminal_velocity)

    if player.is_on_wall_only():
        wall_slide.emit()
    if not player.is_on_floor() and not player.is_on_wall():
        print("AIR")

    if player.facing_direction.x != 0:
        player.flip_anchor.scale.x = sign(facing_direction.x)

    # Move
    player.move_and_slide()
