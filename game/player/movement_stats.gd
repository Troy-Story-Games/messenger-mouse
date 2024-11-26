extends Resource
class_name MovementStats

@export_group("Movement Modifiers")
@export var enemy_kill_boost: = 75.0
@export var enemy_kill_air_boost: = 250.0

@export_group("Ground Movement")
## Horizontal acceleration for a character, applied when on the ground
## while holding left or right direction until ground_max_speed is reached
@export var ground_acceleration: = 300.0
## Threshold to switch to running
@export var ground_run_threshold: = 150.0
## Max horizontal speed
@export var ground_max_speed: = 200.0
## Friction applied to stop the charater when not moving
@export var ground_friction: = 1500.0
## Force applied when jumping off the ground
@export var ground_jump_force: = 350.0
## Friction applied to stop the character when sliding
@export var ground_slide_friction: = 90.0
## Amount added to current speed when pressing the slide button
@export var ground_slide_boost: = 70.0
## Boost applied to ground_jump_force when crouch jumping
@export var ground_slide_launch_boost: = 100.0
## Max speed while crouch walking
@export var ground_crouch_walk_max_speed: = 75.0
## Amount of bounce back when crashing into a wall
@export var ground_slide_wall_crash_bounce: = 250.0
## Amount of up-bounce added when crashing into a wall
@export var ground_slide_wall_crash_up_bounce: = 175.0

@export_group("Climb Movement")
## Fixed verticle speed when climbing
@export var climb_verticle_speed: = 75.0
## Acceleration when climbing (horizontal only)
@export var climb_acceleration: = 2000.0
## Friction applied while climbing (horizontal only)
@export var climb_friction: = 2000.0
## Max horizontal speed when climbing
@export var climb_horizontal_speed: = 20.0

@export_group("Air Movement")
## Fall acceleration applied when the character is moving dowards (e.g. gravity)
@export var gravity: = 1000.0
## Fall acceleration applied when the character is still moving upwards
## While the jump button is held, this number is cut in half.
@export var jump_deceleration: = 700.0
## Max fall speed
@export var terminal_velocity: = 300.0
## Horizontal acceleration in the air. Added to current horizontal movement in the air
## only when holding a directional button.
@export var air_acceleration: = 1200.0
## Max horizontal speed in the air
@export var air_max_speed: = 200.0
## Friction applied to stop horizontal movement in the air. Applied when no directional button
## is being held while in the air.
@export var air_friction: = 900.0
## Force applied when jumping while in the air (double, triple, quadruple, etc. jump)
@export var air_jump_force: = 350.0

@export_group("Wall Movement")
## Fall acceleration when wall sliding
@export var wall_slide_acceleration: = 100.0
## Max fall speed when attached to a wall
@export var wall_slide_max_speed: = 300.0
## Upward force when wall jumping
@export var wall_jump_force: = 350.0
## Horizontal speed when wall jumping. This is the amount you "pop" off the wall
@export var wall_jump_speed: = 50.0
