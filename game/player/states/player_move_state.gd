extends State
class_name PlayerMoveState

const COYOTE_JUMP_REACTION_TIME: = 0.2
const WALL_STICK_TIME: = 0.4

var just_jumped: bool = false
var double_jump: bool = true
var sliding: bool = false
var wall_stick: bool = false
var coyote_jump_timer: SceneTreeTimer
var wall_stick_timer: SceneTreeTimer

func get_input_vector(player: Player) -> Vector2:
    var input_vector: = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    player.facing_direction = input_vector
    player.direction = input_vector
    return input_vector.normalized()

func jump(player: Player, force: float) -> void:
    player.velocity.y = -force

func slide_check(player: Player, delta: float) -> void:
    var slide_just_pressed: bool = Input.is_action_just_pressed("slide")
    var slide_pressed: bool = Input.is_action_pressed("slide")

    if player.is_on_floor() and slide_just_pressed:
        sliding = true
        if player.velocity.x != 0:
            player.velocity.x += player.movement_stats.ground_slide_boost * sign(player.velocity.x)
    if not slide_pressed and not player.ceiling_check_ray_cast_2d.is_colliding():
        sliding = false

func jump_check(player: Player) -> void:
    var jump_just_pressed: bool = Input.is_action_just_pressed("jump")
    if player.is_on_wall_only() and jump_just_pressed:
        # Wall jump
        player.velocity.x = player.get_wall_normal().x * player.movement_stats.wall_jump_speed
        jump(player, player.movement_stats.wall_jump_force)
        just_jumped = true
    elif (player.is_on_floor() or (coyote_jump_timer and coyote_jump_timer.time_left > 0)) and jump_just_pressed:
        # Regular jump
        var force = player.movement_stats.ground_jump_force
        if sliding:
            force += player.movement_stats.ground_slide_launch_boost
        jump(player, force)
        just_jumped = true
    elif jump_just_pressed and double_jump == true:
        # Handle double jump
        jump(player, player.movement_stats.air_jump_force)
        double_jump = false

func apply_horizontal_force(player: Player, input_vector: Vector2, delta: float) -> void:
    var horizontal_velocity = Vector2(player.velocity.x, 0)
    var accel: = player.movement_stats.ground_acceleration
    var friction: = player.movement_stats.ground_friction
    var speed: = player.movement_stats.ground_max_speed

    if not player.is_on_floor() and not player.is_on_wall():  # Air
        accel = player.movement_stats.air_acceleration
        friction = player.movement_stats.air_friction
        speed = player.movement_stats.air_max_speed
    elif sliding:
        accel = player.movement_stats.ground_slide_friction
        friction = player.movement_stats.ground_slide_friction
        speed = player.movement_stats.ground_crouch_walk_max_speed

    if input_vector != Vector2.ZERO and (player.velocity.x == 0 or sign(input_vector.x) == sign(player.velocity.x)):  # Walking/Running
        var new_velocity: = player.direction * speed
        horizontal_velocity = horizontal_velocity.move_toward(new_velocity, accel * delta)
    else:  # Friction
        horizontal_velocity = horizontal_velocity.move_toward(Vector2.ZERO, friction * delta)

    if player.is_on_wall_only() and wall_stick:
        var wall_normal_x = sign(player.get_wall_normal().x)
        var input_x = sign(input_vector.x)
        if wall_normal_x == input_x and wall_stick_timer == null:
            wall_stick_timer = player.get_tree().create_timer(WALL_STICK_TIME)
            wall_stick_timer.timeout.connect(func(): wall_stick = false)
        return  # If we're stuck to the wall, don't apply a horizontal force
    else:
        wall_stick_timer = null
        wall_stick = false

    # Set just the horizontal component
    player.velocity.x = horizontal_velocity.x

func apply_verticle_force(player: Player, delta: float) -> void:
    var accel: = player.movement_stats.gravity
    var max: = player.movement_stats.terminal_velocity

    if player.velocity.y <= 0 and Input.is_action_pressed("jump"):
        accel = player.movement_stats.jump_deceleration
    elif player.velocity.y <= 0 and Input.is_action_just_released("jump"):
        player.velocity.y = player.velocity.y / 2

    if player.is_on_wall_only() and player.velocity.y >= 0:  # Wall slide
        accel = player.movement_stats.wall_slide_acceleration
        max = player.movement_stats.wall_slide_max_speed
    player.velocity.y += accel * delta
    player.velocity.y = min(player.velocity.y, max)

func move(player: Player):
    var was_in_air: = not player.is_on_floor()
    var was_on_floor: = player.is_on_floor()
    var was_on_wall_only: = player.is_on_wall_only()
    var last_velocity: = Vector2(player.velocity)
    var last_position: = player.position

    player.move_and_slide()

    # Happens on landing
    if was_in_air and player.is_on_floor():
        # On landing we get double jump back
        double_jump = true

    # Just left the ground
    if was_on_floor and not player.is_on_floor() and not just_jumped:
        coyote_jump_timer = player.get_tree().create_timer(COYOTE_JUMP_REACTION_TIME)
    if not was_on_wall_only and player.is_on_wall_only() and not just_jumped:
        wall_stick = true

func update_animations(player: Player, input_vector: Vector2) -> void:
    if player.facing_direction.x != 0:
        player.flip_anchor.scale.x = sign(player.facing_direction.x)

    if player.is_on_wall_only():
        player.animation_player.play("jump")
    elif sliding and player.is_on_floor():
        if just_jumped:
            player.animation_player.play("launch")
        else:
            player.animation_player.play("slide")
    elif (just_jumped or not double_jump) and player.velocity.y < 0:
        player.animation_player.play("jump")
    elif not player.is_on_floor() and not player.is_on_wall() and player.velocity.y >= 0:
        player.animation_player.play("fall")
    elif input_vector != Vector2.ZERO and player.is_on_floor():
        if abs(player.velocity.x) < player.movement_stats.ground_max_speed:
            player.animation_player.play("walk")
        else:
            player.animation_player.play("run")
        if sign(player.velocity.x) != sign(input_vector.x):
            player.animation_player.play("skid")
    elif player.is_on_floor():
        player.animation_player.play("idle")

func process_state(delta: float) -> void:
    just_jumped = false
    var player: = actor as Player
    var input_vector: = get_input_vector(player)

    apply_horizontal_force(player, input_vector, delta)
    jump_check(player)
    slide_check(player, delta)
    apply_verticle_force(player, delta)
    update_animations(player, input_vector)
    move(player)
