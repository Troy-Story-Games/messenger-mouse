extends State
class_name PlayerMoveState

const JumpDustEffectScene = preload("res://game/fx/jump_dust_effect.tscn")

const COYOTE_JUMP_REACTION_TIME: = 0.2
const WALL_STICK_TIME: = 0.4
const COMBO_ATTACK_BUTTON_TIME: = 0.3

var just_jumped: bool = false
var double_jump: bool = true
var sliding: bool = false
var climbing: bool = false
var was_just_climbing: bool = false
var wall_stick: bool = false
var super_jump_enabled: bool = false
var konami_code_enabled: bool = false
var side_attack_animations: Array[String] = ["side_down", "side_up"]
var top_attack_animations: Array[String] = ["top_left", "top_right"]
var bottom_attack_animations: Array[String] = ["bottom_left", "bottom_right"]
var combo_attack_animations: Array[String] = []
var last_attack_direction: Vector2 = Vector2.RIGHT

func enter() -> void:
    var player: Player = actor as Player
    player.wall_stick_timer.timeout.connect(func(): wall_stick = false)
    Events.toggle_cheat.connect(_on_toggle_cheat)

func _on_toggle_cheat(cheat_name: String) -> void:
    print_verbose("Toggle cheat! ", cheat_name)
    var player: Player = actor as Player
    match cheat_name:
        "konami_code":
            if not konami_code_enabled:
                print_verbose("KONAMI!")
                konami_code_enabled = true
                player.movement_stats.ground_max_speed *= 2
                player.movement_stats.ground_acceleration *= 2
                player.movement_stats.ground_friction *= 2
                player.movement_stats.ground_slide_boost *= 2
                player.movement_stats.ground_crouch_walk_max_speed *= 2
                player.movement_stats.ground_slide_friction *= 2
                player.movement_stats.air_max_speed *= 2
                player.movement_stats.air_acceleration *= 2
                player.movement_stats.air_friction *= 2
                player.movement_stats.wall_slide_acceleration *= 2
                player.movement_stats.wall_slide_max_speed *= 2
            else:
                konami_code_enabled = false
                player.movement_stats.ground_max_speed /= 2
                player.movement_stats.ground_acceleration /= 2
                player.movement_stats.ground_friction /= 2
                player.movement_stats.ground_slide_boost /= 2
                player.movement_stats.ground_crouch_walk_max_speed /= 2
                player.movement_stats.ground_slide_friction /= 2
                player.movement_stats.air_max_speed /= 2
                player.movement_stats.air_acceleration /= 2
                player.movement_stats.air_friction /= 2
                player.movement_stats.wall_slide_acceleration /= 2
                player.movement_stats.wall_slide_max_speed /= 2
        "super_jump":
            if not super_jump_enabled:
                print_verbose("Super jump!")
                player.movement_stats.ground_jump_force *= 2
                super_jump_enabled = true
            else:
                super_jump_enabled = false
                player.movement_stats.ground_jump_force /= 2

func get_input_vector(player: Player) -> Vector2:
    var input_vector: = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    player.facing_direction = input_vector
    player.direction = input_vector
    return input_vector.normalized()

func jump(player: Player, force: float) -> void:
    player.velocity.y = -force

func slide_check(player: Player, _delta: float) -> void:
    var slide_just_pressed: bool = Input.is_action_just_pressed("slide")
    var slide_pressed: bool = Input.is_action_pressed("slide")

    if player.is_on_floor() and slide_just_pressed:
        sliding = true
        if player.velocity.x != 0:
            player.velocity.x += player.movement_stats.ground_slide_boost * sign(player.velocity.x)
    if not slide_pressed and not player.ceiling_check_ray_cast_2d.is_colliding():
        sliding = false
    if not player.is_on_floor():
        sliding = false

func jump_check(player: Player) -> void:
    var jump_just_pressed: bool = Input.is_action_just_pressed("jump")
    if player.is_on_wall_only() and jump_just_pressed:
        # Wall jump
        player.velocity.x = player.get_wall_normal().x * player.movement_stats.wall_jump_speed
        jump(player, player.movement_stats.wall_jump_force)
        just_jumped = true
        SoundFx.play("jump")
        var dust_effect: AnimatedSpriteEffect = Utils.instantiate_scene_on_level(JumpDustEffectScene, player.global_position) as AnimatedSpriteEffect
        var rotation = deg_to_rad(90 * sign(player.get_wall_normal().x))
        dust_effect.rotate(rotation)
        dust_effect.position.x += 5 * sign(player.get_wall_normal().x)
    elif ((player.is_on_floor() or climbing) or player.coyote_jump_timer.time_left > 0) and jump_just_pressed:
        # Regular jump
        var force = player.movement_stats.ground_jump_force
        if sliding:
            SoundFx.play("launch")
            force += player.movement_stats.ground_slide_launch_boost
        else:
            SoundFx.play("jump")
        jump(player, force)
        just_jumped = true
        Utils.instantiate_scene_on_level(JumpDustEffectScene, player.global_position)
    elif jump_just_pressed and double_jump == true:
        # Handle double jump
        jump(player, player.movement_stats.air_jump_force)
        double_jump = false
        SoundFx.play("double_jump")

func climb_check(player: Player) -> void:
    if not player.climb_area_2d.has_overlapping_bodies():
        climbing = false
        was_just_climbing = false
        return

    var climb_action_just_pressed = Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")
    var climb_action_pressed = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")

    if climb_action_just_pressed:
        climbing = true
        was_just_climbing = false
    elif just_jumped and climbing:
        was_just_climbing = true
        climbing = false
    elif not player.is_on_floor() and not player.is_on_wall() and not climbing and not was_just_climbing and climb_action_pressed:
        climbing = true  # Grab a laddar from mid-air
        was_just_climbing = false
    elif not player.is_on_floor() and not player.is_on_wall() and was_just_climbing and climb_action_pressed and player.velocity.y >= 0:
        climbing = true
        was_just_climbing = false

    if not climbing:
        return

    # down - up b/c up is negative and down is positive
    var climb_dir: = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    player.velocity.y = player.movement_stats.climb_verticle_speed * climb_dir

func apply_horizontal_force(player: Player, input_vector: Vector2, delta: float) -> void:
    var horizontal_velocity = Vector2(player.velocity.x, 0)
    var accel: = player.movement_stats.ground_acceleration
    var friction: = player.movement_stats.ground_friction
    var speed: = player.movement_stats.ground_max_speed

    if not player.is_on_floor() and not player.is_on_wall() and not climbing:  # Air
        accel = player.movement_stats.air_acceleration
        friction = player.movement_stats.air_friction
        speed = player.movement_stats.air_max_speed
    elif sliding:
        accel = player.movement_stats.ground_slide_friction
        friction = player.movement_stats.ground_slide_friction
        speed = player.movement_stats.ground_crouch_walk_max_speed
    elif climbing:
        accel = player.movement_stats.climb_acceleration
        friction = player.movement_stats.climb_friction
        speed = player.movement_stats.climb_horizontal_speed

    if input_vector != Vector2.ZERO and (player.velocity.x == 0 or sign(input_vector.x) == sign(player.velocity.x)):  # Walking/Running
        var new_velocity: = player.direction * speed
        horizontal_velocity = horizontal_velocity.move_toward(new_velocity, accel * delta)
    else:  # Friction
        horizontal_velocity = horizontal_velocity.move_toward(Vector2.ZERO, friction * delta)

    if player.is_on_wall_only() and wall_stick:
        var wall_normal_x = sign(player.get_wall_normal().x)
        var input_x = sign(input_vector.x)
        if wall_normal_x == input_x and player.wall_stick_timer.is_stopped():
            player.wall_stick_timer.start(WALL_STICK_TIME)
        return  # If we're stuck to the wall, don't apply a horizontal force
    else:
        player.wall_stick_timer.stop()
        wall_stick = false

    # Set just the horizontal component
    player.velocity.x = horizontal_velocity.x

func apply_verticle_force(player: Player, delta: float) -> void:
    var accel: = player.movement_stats.gravity
    var max_vel: = player.movement_stats.terminal_velocity

    if player.velocity.y <= 0 and Input.is_action_pressed("jump"):
        accel = player.movement_stats.jump_deceleration
    elif player.velocity.y <= 0 and Input.is_action_just_released("jump"):
        player.velocity.y = player.velocity.y / 2
    
    if player.velocity.y >= 0 and Input.is_action_just_pressed("move_down"):
        player.velocity.y = player.movement_stats.fast_fall_terminal_velocity

    if player.is_on_wall_only() and player.velocity.y >= 0:  # Wall slide
        accel = player.movement_stats.wall_slide_acceleration
        max_vel = player.movement_stats.wall_slide_max_speed
    player.velocity.y += accel * delta
    player.velocity.y = min(player.velocity.y, max_vel)

func move(player: Player, _delta: float):
    var was_in_air: = not player.is_on_floor()
    var was_on_floor: = player.is_on_floor()
    var was_on_wall_only: = player.is_on_wall_only()
    var was_on_wall: = player.is_on_wall()
    var orig_velocity: = Vector2(player.velocity)

    player.move_and_slide()

    # Crash bounce and shake
    if not was_on_wall and player.is_on_wall() and sliding and abs(orig_velocity.x) >= (player.movement_stats.ground_max_speed * 0.90):
        Events.request_camera_screenshake.emit(2, 0.3)
        player.velocity = player.get_wall_normal() * player.movement_stats.ground_slide_wall_crash_bounce
        player.velocity.y = -player.movement_stats.ground_slide_wall_crash_up_bounce
        player.move_and_slide()
        SoundFx.play("slide_bang")

    # Happens on landing
    if was_in_air and player.is_on_floor():
        # On landing we get double jump back
        double_jump = true
        SoundFx.play("landing")

    # Just left the ground
    if was_on_floor and not player.is_on_floor() and not just_jumped:
        player.coyote_jump_timer.start(COYOTE_JUMP_REACTION_TIME)

    # Just attached to a wall
    if not was_on_wall_only and player.is_on_wall_only() and not just_jumped:
        wall_stick = true

func update_animations(player: Player, input_vector: Vector2) -> void:
    if player.facing_direction.x != 0:
        player.flip_anchor.scale.x = sign(player.facing_direction.x)

    if player.is_on_wall_only():
        var wall_normal: = player.get_wall_normal()
        if sign(wall_normal.x) == sign(input_vector.x):
            player.animation_player.play("skid")
        else:
            player.animation_player.play("wall_grab")
    elif sliding and player.is_on_floor():
        if just_jumped:
            player.animation_player.play("launch")
        else:
            player.animation_player.play("crouch")
    elif climbing:
        player.animation_player.play("climb")
    elif (just_jumped or not double_jump) and player.velocity.y < 0:
        if just_jumped or was_just_climbing:
            player.animation_player.play("jump")
        elif not double_jump:
            player.animation_player.play("flip")
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
        if Input.is_action_pressed("move_down"):
            player.animation_player.play("crouch")
        else:
            player.animation_player.play("idle")

    # Walk and run SoundFX
    if player.animation_player.is_playing() and player.animation_player.current_animation == "walk":
        if not player.walk_sound_fx.playing:
            player.walk_sound_fx.play()
        player.walk_sound_fx.pitch_scale = 1.60
    elif player.animation_player.is_playing() and player.animation_player.current_animation == "run":
        if not player.walk_sound_fx.playing:
            player.walk_sound_fx.play()
        player.walk_sound_fx.pitch_scale = 2.2
    else:
        player.walk_sound_fx.stop()

func update_attack_animations(player: Player, input_vector: Vector2) -> void:
    if sliding or climbing or player.is_on_wall_only() or (player.is_on_floor() and Input.is_action_pressed("move_down")):
        return

    if not Input.is_action_just_pressed("attack"):
        return

    var attack_direction: = Vector2.RIGHT
    var attack_list: Array[String] = side_attack_animations
    if Input.is_action_pressed("move_up"):
        attack_direction = Vector2.UP
        attack_list = top_attack_animations
    elif Input.is_action_pressed("move_down") and not player.is_on_floor() and not player.is_on_wall():
        attack_direction = Vector2.DOWN
        attack_list = bottom_attack_animations
    elif input_vector.x > 0:
        attack_direction = Vector2.RIGHT
    elif input_vector.x < 0:
        attack_direction = Vector2.LEFT

    if player.combo_attack_timer.time_left == 0 or attack_direction != last_attack_direction:
        player.combo_attack_timer.stop()
        combo_attack_animations = attack_list.duplicate()
        last_attack_direction = attack_direction

    player.combo_attack_timer.start(COMBO_ATTACK_BUTTON_TIME)
    var next_attack: String = combo_attack_animations.pop_front()
    combo_attack_animations.append(next_attack)
    player.attack_animation_player.play(next_attack)

    SoundFx.play("slash")


func process_state(delta: float) -> void:
    just_jumped = false
    var player: = actor as Player
    var input_vector: = get_input_vector(player)

    apply_horizontal_force(player, input_vector, delta)
    apply_verticle_force(player, delta)
    jump_check(player)
    slide_check(player, delta)
    climb_check(player)
    update_animations(player, input_vector)
    update_attack_animations(player, input_vector)
    move(player, delta)
